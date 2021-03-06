import Foundation
import StdMsgs
import RosTime


extension sensor_msgs {
public struct JoyFeedback: Message {
public static var md5sum: String = "f4dcd73460360d98f36e55ee7f2e46f1"
public static var datatype = "sensor_msgs/JoyFeedback"
public static var definition = """
# Declare of the type of feedback
uint8 TYPE_LED    = 0
uint8 TYPE_RUMBLE = 1
uint8 TYPE_BUZZER = 2

uint8 type

# This will hold an id number for each type of each feedback.
# Example, the first led would be id=0, the second would be id=1
uint8 id

# Intensity of the feedback, from 0.0 to 1.0, inclusive.  If device is
# actually binary, driver should treat 0<=x<0.5 as off, 0.5<=x<=1 as on.
float32 intensity
"""
public static var hasHeader = false

public let TYPE_LED : UInt8 = 0
public let TYPE_RUMBLE : UInt8 = 1
public let TYPE_BUZZER : UInt8 = 2
public var type: UInt8
public var id: UInt8
public var intensity: Float32

public init(type: UInt8, id: UInt8, intensity: Float32) {
self.type = type
self.id = id
self.intensity = intensity
}

public init() {
    type = UInt8()
id = UInt8()
intensity = Float32()
}

}
}