import Flutter
import UIKit

public class LocationBeaconsPlugin: NSObject, FlutterPlugin {
    private lazy var geolocationHandler: GeolocationHandler = {
        return GeolocationHandler()
    }()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = LocationBeaconsPlugin()
        let channel = FlutterMethodChannel(name: "location_beacons_ios", binaryMessenger: registrar.messenger())
        let positionUpdatesEventChannel = FlutterEventChannel(name: "location_beacons_ios/position_updates",
                                                              binaryMessenger: registrar.messenger())
        let positionHandler = PositionStreamHandler(instance.geolocationHandler)                                                              
        positionUpdatesEventChannel.setStreamHandler(positionHandler)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getLastKnownPosition":
            let location = geolocationHandler.getLasKnownPosition()
            result(location?.toDictionary)
        case "getCurrentPosition":
            onGetCurrentPosition(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func onGetCurrentPosition(result: @escaping FlutterResult) {
        geolocationHandler.requestPosition(resultHandler: { location in
            result(location?.toDictionary)
        }, errorHandler: { errorCode, errorDescription in
            result(FlutterError(code: errorCode.rawValue, message: errorDescription, details: nil))
        })
    }
}
