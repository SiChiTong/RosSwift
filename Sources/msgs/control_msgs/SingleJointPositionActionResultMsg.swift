import Foundation
import StdMsgs
import RosTime
import actionlib_msgs

extension control_msgs {
public struct SingleJointPositionActionResult: Message {
public static var md5sum: String = "1eb06eeff08fa7ea874431638cb52332"
public static var datatype = "control_msgs/SingleJointPositionActionResult"
public static var definition = """
# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======

Header header
actionlib_msgs/GoalStatus status
SingleJointPositionResult result
"""
public static var hasHeader = false

public var header: std_msgs.header
public var status: actionlib_msgs.GoalStatus
public var result: SingleJointPositionResult

public init(header: std_msgs.header, status: actionlib_msgs.GoalStatus, result: SingleJointPositionResult) {
self.header = header
self.status = status
self.result = result
}

public init() {
    header = std_msgs.header()
status = actionlib_msgs.GoalStatus()
result = SingleJointPositionResult()
}

}
}