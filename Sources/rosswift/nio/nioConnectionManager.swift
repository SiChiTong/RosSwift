//
//  XmlRpcServer.swift
//  swiftros
//
//  Created by Thomas Gustafsson on 2018-03-22.
//

import Foundation
import NIO
import NIOConcurrencyHelpers
//import NIOHTTP1
import XMLRPCSerialization
import StdMsgs
import BinaryCoder

struct nio {}


extension Ros {
class ConnectionHandler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    typealias InboundOut = ByteBuffer

    private var subscriber: TransportSubscriberLink?
    private var serviceclient: ServiceClientLink?

    var header = Header()

    func channelInactive(ctx: ChannelHandlerContext) {
        subscriber?.drop()
        serviceclient?.drop()
//        ROS_DEBUG("ConnectionHandler channelInactive for port \(ctx.channel.localAddress!.port!)")
        ctx.fireChannelInactive()
    }

    enum State {
        case header
        case serviceCall
    }

    var state = State.header

    public func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
//        ROS_DEBUG("message from \(ctx.channel.remoteAddress) => \(ctx.channel.localAddress)")
        var buffer = self.unwrapInboundIn(data)

        switch state {
        case .header:
            guard let len : UInt32 = buffer.readInteger(endianness: .little) else {
                fatalError()
            }
            precondition(len <= buffer.readableBytes)
            let leave = buffer.readableBytes - Int(len)
                var readMap = [String:String]()

                while buffer.readableBytes > leave {
                    guard let topicLen : UInt32 = buffer.readInteger(endianness: .little) else {
                        ROS_DEBUG("Received an invalid TCPROS header.  invalid string")
                        return
                    }

                    guard let line = buffer.readString(length: Int(topicLen)) else {
                        ROS_DEBUG("Received an invalid TCPROS header.  Each line must have an equals sign.")
                        return
                    }

                    guard let eq = line.index(of: "=") else {
                        ROS_DEBUG("Received an invalid TCPROS header.  Each line must have an equals sign.")
                        return
                    }
                    let key = String(line.prefix(upTo: eq))
                    let value = String(line.suffix(from: eq).dropFirst())
                    readMap[key] = value
                }

                ROS_DEBUG(readMap.description)

                if let error = readMap["error"] {
                    ROS_ERROR("Received error message in header for connection to [\(ctx.remoteAddress?.description ?? "empty")]]: [\(error)]")
                    return
                }

                header.read_map_ = readMap

                // Connection Header Received

                if let topic = readMap["topic"], let remote = ctx.remoteAddress {
                    let conn = nio.Connection(transport: ctx.channel, header: header)
                    ROS_DEBUG("Connection: Creating TransportSubscriberLink for topic [\(topic)] connected to [\(remote)]")
                    let sub_link = TransportSubscriberLink(connection: conn)
                    if sub_link.handleHeader(header: header) {
                        subscriber = sub_link
                    } else {
                        sub_link.drop()
                    }
                } else if let val = header.getValue(key: "service") {
                    ROS_DEBUG("Connection: Creating ServiceClientLink for service [\(val)] connected to [\(String(describing: ctx.remoteAddress!.description))]")
                    let conn = nio.Connection(transport: ctx.channel, header: header)

                    let link = ServiceClientLink()
                    link.initialize(connection: conn)
                    if link.handleHeader(header: header) {
                        serviceclient = link
                    }
                    state = .serviceCall
                } else {
                    ROS_ERROR("Got a connection for a type other than 'topic' or 'service' from [\(String(describing: ctx.remoteAddress?.description))].  Fail.")
                    fatalError()
            }

        case .serviceCall:
            if let rawMessage = buffer.readBytes(length: buffer.readableBytes) {
                guard let link = serviceclient else {
                    ROS_ERROR("ServiceCall not able process: link is missing")
                    ctx.close(promise: nil)
                    return
                }


                if let response = link.parent?.processRequest(buf: rawMessage) {
                    let rawResponse = SerializedMessage(msg: response)
                    var buf = ctx.channel.allocator.buffer(capacity: rawResponse.buf.count + 1)
                    buf.write(bytes: [UInt8(1)]+rawResponse.buf)  // Start with Bool(true)
                    let niodata = self.wrapInboundOut(buf)

                    ctx.writeAndFlush(niodata, promise: nil)
                } else {
                    ROS_WARNING("ServiceCall not able process")
                    ctx.close(promise: nil)
                }
            }
            state = .header
        }


    }

    func errorCaught(ctx: ChannelHandlerContext, error: Error) {
        ROS_ERROR(error.localizedDescription)
    }


}

class ConnectionManager {
    static var instance = ConnectionManager()

//    let handler = ConnectionHandler()
    var channel : Channel? = nil
    var boot : ServerBootstrap? = nil

    private init() {}

    deinit {
        ROS_DEBUG("ConnectionManager deinit")
    }

    func getTCPPort() -> Int32 {
        return Int32(channel?.localAddress?.port ?? 0)
    }

    func clear(reason: DropReason) {
        fatalError()
    }

    func shutdown() {
    }

    // The connection ID counter, used to assign unique ID to each inbound or
    // outbound connection.  Access via getNewConnectionID()
    private var connection_id_counter_ = Atomic<Int>(value: 0)


    func getNewConnectionID() -> Int {
        return connection_id_counter_.add(1)
    }

    func addConnection(connection: ConnectionProtocol) {
//        connections_mutex_.sync {
//            connections_.append(connection)
//            NotificationCenter.default.addObserver(self, selector: #selector(onConnectionDropped(_:)), name: Connection.dropNotification, object: connection)
//        }
    }

    

    func start() {
//        NotificationCenter.default.addObserver(self, selector: #selector(removeDroppedConnections(_:)), name: PollManager.notification, object: pm)

        initialize(group: thread_group)
        do {
            let addr = try SocketAddress.newAddressResolving(host: Ros.network.getHost(), port: 0)


            channel = try boot?.bind(host: Ros.network.getHost(), port: 0).wait()
            ROS_DEBUG("listening channel on port [\(channel?.localAddress?.host):\(getTCPPort())]")

        } catch {
            ROS_ERROR("Could not bind to [\(getTCPPort())]: \(error)")
        }
    }

    private func initialize(group: EventLoopGroup) {

        boot = ServerBootstrap(group: group)
            // Specify backlog and enable SO_REUSEADDR for the server itself
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.autoRead, value: true)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_KEEPALIVE), value: 1)

            // Set the handlers that are appled to the accepted Channels
            .childChannelInitializer { $0.pipeline.addHandlers([nio.MessageDelimiterCodec(),ConnectionHandler()], first: true) }

            // Enable TCP_NODELAY and SO_REUSEADDR for the accepted Channels
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
            .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())


    }

    func bind(host: String, port: Int) {
        do {
            channel = try boot?.bind(host: Ros.network.getHost(), port: 0).wait()
        } catch {
            ROS_ERROR("Could not bind to [::1:\(port)]: \(error)")
        }
    }

}

}
