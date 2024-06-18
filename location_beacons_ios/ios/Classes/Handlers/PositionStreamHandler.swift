import Foundation
import CoreLocation
import Flutter

class PositionStreamHandler: NSObject, FlutterStreamHandler {
    
    weak private var  geolocationHandler: GeolocationHandler?
    private var eventSink: FlutterEventSink?
    
    init(_ geolocationHandler: GeolocationHandler) {
        self.geolocationHandler = geolocationHandler
        super.init()
    }
    
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        guard let geolocationHandler = geolocationHandler else { return nil }
        
        if (self.eventSink != nil) {
            let errorCode = ErrorCodes.GeolocatorErrorLocationSubscriptionActive
            return FlutterError(code: errorCode.rawValue,
                                message: "Already listening for location updates. If you want to restart listening please cancel other subscriptions first.",
                                details: nil)
        }
        
        self.eventSink = eventSink
        
        var pauseLocationUpdatesAutomatically: Bool
        var activityType: CLActivityType
        var allowBackgroundLocationUpdates: Bool
        var showBackgroundLocationIndicator: Bool
        if let arguments = arguments {
            let argumentsMap = arguments as! NSDictionary
            pauseLocationUpdatesAutomatically = argumentsMap["pauseLocationUpdatesAutomatically"] as! Bool
            activityType = argumentsMap["activity_type"] as! CLActivityType
            allowBackgroundLocationUpdates = argumentsMap["allowBackgroundLocationUpdates"] as! Bool
            showBackgroundLocationIndicator = argumentsMap["showBackgroundLocationIndicator"] as! Bool
        } else {
            pauseLocationUpdatesAutomatically = false
            activityType = CLActivityType.other
            allowBackgroundLocationUpdates = false
            showBackgroundLocationIndicator = false
        }
        
        geolocationHandler.startListening(pauseLocationUpdatesAutomatically: pauseLocationUpdatesAutomatically,
                                          activityType: activityType,
                                          showBackgroundLocationIndicator: showBackgroundLocationIndicator,
                                          allowBackgroundLocationUpdates: allowBackgroundLocationUpdates,
                                          resultHandler: { [weak self] location in
            guard let self = self else { return }
            onLocationDidChange(location: location)
        },
                                          errorHandler: {[weak self] (errorCode, errorDescription) in
            guard let self = self else { return }
            onLocationFailureWithErrorCode(errorCode: errorCode, errorDescription: errorDescription)
        }
        )
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        guard let geolocationHandler = geolocationHandler else { return nil }
        geolocationHandler.stopListening()
        eventSink = nil
        
        return nil
    }
    
    private func onLocationDidChange(location: CLLocation?) {
        if (eventSink == nil) {
            return
        }
        eventSink!(location?.toDictionary)
    }
    
    private func onLocationFailureWithErrorCode(errorCode: ErrorCodes, errorDescription: String) {
        if (eventSink == nil) {
            return
        }
        eventSink!(FlutterError(code: errorCode.rawValue, message: errorDescription, details: nil))
    }
}
