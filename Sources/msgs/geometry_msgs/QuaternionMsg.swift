import Foundation
import StdMsgs
import RosTime


extension geometry_msgs {
public struct Quaternion: Message {
public static var md5sum: String = "a779879fadf0160734f906b8c19c7004"
public static var datatype = "geometry_msgs/Quaternion"
public static var definition = """
# This represents an orientation in free space in quaternion form.

float64 x
float64 y
float64 z
float64 w
"""
public static var hasHeader = false

public var x: Float64
public var y: Float64
public var z: Float64
public var w: Float64

public init(x: Float64, y: Float64, z: Float64, w: Float64) {
self.x = x
self.y = y
self.z = z
self.w = w
}

public init() {
    x = Float64()
y = Float64()
z = Float64()
w = Float64()
}

}
}