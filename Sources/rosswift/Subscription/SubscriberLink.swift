//
//  SubscriberLink.swift
//  RosSwift
//
//  Created by Thomas Gustafsson on 2018-03-05.
//

import Foundation
import StdMsgs

protocol SubscriberLink: class {
    var parent : Publication! { get }
    var connection_id : UInt { get }
    var destination_caller_id  : String { get }
    var topic : String { get }

    func drop()
    func isIntraprocess() -> Bool
    func enqueueMessage(m: SerializedMessage, ser: Bool, nocopy: Bool)

}

extension SubscriberLink {
    func getDataType() -> String {
        return parent.datatype
    }

    func getMD5Sum() -> String {
        return parent.md5sum
    }

    func getMessageDefinition() -> String {
        return parent.message_definition
    }

    func getPublishTypes(ser: inout Bool, nocopy: inout Bool, ti: TypeInfo) {
        ser = true
        nocopy = false
    }
}

/*
class SubscriberLink {
    weak var parent : Publication!
    var connection_id : UInt = 0
    var destination_caller_id  = ""
    var topic = ""

    func drop() {
        ROS_DEBUG("SubscriberLink drop not implemented")
    }

    func enqueueMessage(m: SerializedMessage, ser: Bool, nocopy: Bool) {
        ROS_DEBUG("SubscriberLink enqueueMessage not implemented")
    }


    func isIntraprocess() -> Bool {
        return false
    }

    func getPublishTypes(ser: inout Bool, nocopy: inout Bool, ti: TypeInfo) {
        ser = true
        nocopy = false
    }

    func getDataType() -> String {
        return parent.datatype
    }

    func getMD5Sum() -> String {
        return parent.md5sum
    }

    func getMessageDefinition() -> String {
        return parent.message_definition
    }

}
*/
