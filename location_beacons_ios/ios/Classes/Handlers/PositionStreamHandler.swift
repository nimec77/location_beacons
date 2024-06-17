import Flutter

class PositionStreamHandler: NSObject, FlutterStreamHandler {
    
    private let  geolocationHandler: GeolocationHandler
    private var eventSink: FlutterEventSink?
    
    init(geolocationHandler: GeolocationHandler) {
        self.geolocationHandler = geolocationHandler
    }

    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        if (self.eventSink != nil) {
            return FlutterError(code: GeolocatorErrorLocationSubscriptionActive, 
                message: "Already listening for location updates. If you want to restart listening please cancel other subscriptions first.", 
                details: nil)
        }

        self.eventSink = eventSink

        let argumentsMap = arguments as! NSDictionary
        let pauseLocationUpdatesAutomatically = argumentsMap["pauseLocationUpdatesAutomatically"] as! Bool
        let activityType = argumentsMap["activityType"] as! CLActivityType
        let allowBackgroundLocationUpdates = argumentsMap["allowBackgroundLocationUpdates"] as! Bool
        let showBackgroundLocationIndicator = argumentsMap["showBackgroundLocationIndicator"] as! Bool

        geolocationHandler.startListening(pauseLocationUpdatesAutomatically: pauseLocationUpdatesAutomatically, 
            activityType: activityType, 
            showBackgroundLocationIndicator: showBackgroundLocationIndicator, 
            allowBackgroundLocationUpdates: allowBackgroundLocationUpdates)

        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        geolocationHandler.stopListening()
        eventSink = nil
        
        return nil
    }

    private func onLocationDidChange(location: CLLocation?) {
        if (eventSink == nil) {
            return
        }
        eventSink!(location?.toDictionary())
    }
}
