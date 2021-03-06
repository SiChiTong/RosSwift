import Foundation
import StdMsgs
import RosTime


extension sensor_msgs {
public struct JointState: Message {
public static var md5sum: String = "3066dcd76a6cfaef579bd0f34173e9fd"
public static var datatype = "sensor_msgs/JointState"
public static var definition = """
# This is a message that holds data to describe the state of a set of torque controlled joints. 
#
# The state of each joint (revolute or prismatic) is defined by:
#  * the position of the joint (rad or m),
#  * the velocity of the joint (rad/s or m/s) and 
#  * the effort that is applied in the joint (Nm or N).
#
# Each joint is uniquely identified by its name
# The header specifies the time at which the joint states were recorded. All the joint states
# in one message have to be recorded at the same time.
#
# This message consists of a multiple arrays, one for each part of the joint state. 
# The goal is to make each of the fields optional. When e.g. your joints have no
# effort associated with them, you can leave the effort array empty. 
#
# All arrays in this message should have the same size, or be empty.
# This is the only way to uniquely associate the joint name with the correct
# states.


Header header

string[] name
float64[] position
float64[] velocity
float64[] effort
"""
public static var hasHeader = false

public var header: std_msgs.header
public var name: [String]
public var position: [Float64]
public var velocity: [Float64]
public var effort: [Float64]

public init(header: std_msgs.header, name: [String], position: [Float64], velocity: [Float64], effort: [Float64]) {
self.header = header
self.name = name
self.position = position
self.velocity = velocity
self.effort = effort
}

public init() {
    header = std_msgs.header()
name = [String]()
position = [Float64]()
velocity = [Float64]()
effort = [Float64]()
}

}
}