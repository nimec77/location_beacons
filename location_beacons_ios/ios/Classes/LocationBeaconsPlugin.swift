import Flutter
import UIKit

public class LocationBeaconsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "location_beacons_ios", binaryMessenger: registrar.messenger())
        let positionUpdatesEventChannel = FlutterEventChannel(name: "location_beacons_ios/position_updates",
                                                              binaryMessenger: registrar.messenger())
        positionUpdatesEventChannel.setStreamHandler(PositionStreamHandler())
        let instance = LocationBeaconsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
