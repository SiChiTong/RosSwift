import Foundation
import StdMsgs
import RosTime


extension rosgraph_msgs {
public struct TopicStatistics: Message {
public static var md5sum: String = "10152ed868c5097a5e2e4a89d7daa710"
public static var datatype = "rosgraph_msgs/TopicStatistics"
public static var definition = """
# name of the topic
string topic

# node id of the publisher
string node_pub

# node id of the subscriber
string node_sub

# the statistics apply to this time window
time window_start
time window_stop

# number of messages delivered during the window
int32 delivered_msgs
# numbers of messages dropped during the window
int32 dropped_msgs

# traffic during the window, in bytes
int32 traffic

# mean/stddev/max period between two messages
duration period_mean
duration period_stddev
duration period_max

# mean/stddev/max age of the message based on the
# timestamp in the message header. In case the
# message does not have a header, it will be 0.
duration stamp_age_mean
duration stamp_age_stddev
duration stamp_age_max
"""
public static var hasHeader = false

public var topic: String
public var node_pub: String
public var node_sub: String
public var window_start: RosTime.TimeBase
public var window_stop: RosTime.TimeBase
public var delivered_msgs: Int32
public var dropped_msgs: Int32
public var traffic: Int32
public var period_mean: RosTime.Duration
public var period_stddev: RosTime.Duration
public var period_max: RosTime.Duration
public var stamp_age_mean: RosTime.Duration
public var stamp_age_stddev: RosTime.Duration
public var stamp_age_max: RosTime.Duration

public init(topic: String, node_pub: String, node_sub: String, window_start: RosTime.TimeBase, window_stop: RosTime.TimeBase, delivered_msgs: Int32, dropped_msgs: Int32, traffic: Int32, period_mean: RosTime.Duration, period_stddev: RosTime.Duration, period_max: RosTime.Duration, stamp_age_mean: RosTime.Duration, stamp_age_stddev: RosTime.Duration, stamp_age_max: RosTime.Duration) {
self.topic = topic
self.node_pub = node_pub
self.node_sub = node_sub
self.window_start = window_start
self.window_stop = window_stop
self.delivered_msgs = delivered_msgs
self.dropped_msgs = dropped_msgs
self.traffic = traffic
self.period_mean = period_mean
self.period_stddev = period_stddev
self.period_max = period_max
self.stamp_age_mean = stamp_age_mean
self.stamp_age_stddev = stamp_age_stddev
self.stamp_age_max = stamp_age_max
}

public init() {
    topic = String()
node_pub = String()
node_sub = String()
window_start = RosTime.TimeBase()
window_stop = RosTime.TimeBase()
delivered_msgs = Int32()
dropped_msgs = Int32()
traffic = Int32()
period_mean = RosTime.Duration()
period_stddev = RosTime.Duration()
period_max = RosTime.Duration()
stamp_age_mean = RosTime.Duration()
stamp_age_stddev = RosTime.Duration()
stamp_age_max = RosTime.Duration()
}

}
}