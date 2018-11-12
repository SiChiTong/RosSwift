import Foundation
import StdMsgs
import RosTime
import trajectory_msgs

extension control_msgs {
public struct JointTrajectoryGoal: Message {
public static var md5sum: String = "2a0eff76c870e8595636c2a562ca298e"
public static var datatype = "control_msgs/JointTrajectoryGoal"
public static var definition = """
# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
trajectory_msgs/JointTrajectory trajectory
"""
public static var hasHeader = false

public var trajectory: trajectory_msgs.JointTrajectory

public init(trajectory: trajectory_msgs.JointTrajectory) {
self.trajectory = trajectory
}

public init() {
    trajectory = trajectory_msgs.JointTrajectory()
}

}
}