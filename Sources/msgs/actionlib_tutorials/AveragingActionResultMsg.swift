import Foundation
import StdMsgs
import RosTime
import actionlib_msgs

extension actionlib_tutorials {
public struct AveragingActionResult: Message {
public static var md5sum: String = "8672cb489d347580acdcd05c5d497497"
public static var datatype = "actionlib_tutorials/AveragingActionResult"
public static var definition = """
# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======

Header header
actionlib_msgs/GoalStatus status
AveragingResult result
"""
public static var hasHeader = false

public var header: std_msgs.header
public var status: actionlib_msgs.GoalStatus
public var result: AveragingResult

public init(header: std_msgs.header, status: actionlib_msgs.GoalStatus, result: AveragingResult) {
self.header = header
self.status = status
self.result = result
}

public init() {
    header = std_msgs.header()
status = actionlib_msgs.GoalStatus()
result = AveragingResult()
}

}
}