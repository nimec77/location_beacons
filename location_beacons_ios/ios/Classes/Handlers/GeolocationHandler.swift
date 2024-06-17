//
//  GeolocationHandler.swift
//  LocationBeaconsApp
//
//  Created by Dmitry Seloustev on 11.06.2024.
//

import Combine
import CoreLocation

typealias GeolocatorResult = (CLLocation?) -> Void
typealias GeolocatorError = (ErrorCodes, String) -> Void

class GeolocationHandler: NSObject, CLLocationManagerDelegate {
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        
        return manager
    }()
    
    private var isListeningForPositionUpdates = false
    
    private var errorHandler: GeolocatorError? = nil
    
    private var currentLocationResultHandler: GeolocatorResult? = nil
    
    private var listenerResultHandler: GeolocatorResult? = nil
    
    func getLasKnownPosition() -> CLLocation? {
        return locationManager.location
    }
    
    func requestPosition(resultHandler: @escaping GeolocatorResult, errorHandler: @escaping GeolocatorError) {
        self.currentLocationResultHandler = resultHandler
        self.errorHandler = errorHandler
        
        var showBackgroundLocationIndicator = false
        var allowBackgroundLocationUpdates = false
        if (isListeningForPositionUpdates) {
            showBackgroundLocationIndicator = locationManager.showsBackgroundLocationIndicator
            allowBackgroundLocationUpdates = locationManager.allowsBackgroundLocationUpdates
        }
        startMonitoring(pauseLocationUpdatesAutomatically: false, activityType: CLActivityType.other ,
                        isListeningForPositionUpdates: isListeningForPositionUpdates, showBackgroundLocationIndicator: showBackgroundLocationIndicator,
                        allowBackgroundLocationUpdates: allowBackgroundLocationUpdates)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (listenerResultHandler == nil && currentLocationResultHandler == nil) {
            return
        }
        
        guard let location = locations.last else { return }
        
        if (currentLocationResultHandler != nil) {
            currentLocationResultHandler!(location)
        }
        if (listenerResultHandler != nil) {
            listenerResultHandler!(location)
        }
        
        currentLocationResultHandler = nil
        if (!isListeningForPositionUpdates) {
            stopMonitoring()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        if let locationError = error as? CLError {
            print("LOCATION UPDATE FAILURE:",
                  "Error code: \(locationError.errorCode)",
                  "Error description: \(locationError.localizedDescription)", separator: "\n")
            if (locationError.code == CLError.locationUnknown) {
                return
            }
        } else {
            print("LOCATION UPDATE FAILURE:",
                  "Error description: \(error.localizedDescription)", separator: "\n")
            
        }
        
        if (errorHandler != nil) {
            errorHandler!(ErrorCodes.GeolocatorErrorLocationUpdateFailure, error.localizedDescription)
        }
        
        currentLocationResultHandler = nil
        if (!isListeningForPositionUpdates) {
            stopMonitoring()
        }
    }
    
    func startListening(pauseLocationUpdatesAutomatically: Bool, activityType: CLActivityType, showBackgroundLocationIndicator: Bool,
                        allowBackgroundLocationUpdates: Bool, resultHandler: @escaping GeolocatorResult, errorHandler: @escaping GeolocatorError) {
        self.errorHandler = errorHandler
        self.listenerResultHandler = resultHandler
        
        startMonitoring(pauseLocationUpdatesAutomatically: pauseLocationUpdatesAutomatically, activityType: activityType, isListeningForPositionUpdates: true, showBackgroundLocationIndicator: showBackgroundLocationIndicator, allowBackgroundLocationUpdates: allowBackgroundLocationUpdates)
    }
    
    private func stopMonitoring() {
        locationManager.stopMonitoringSignificantLocationChanges()
        isListeningForPositionUpdates = false
        errorHandler = nil
        listenerResultHandler = nil
    }
    
    private func startMonitoring(pauseLocationUpdatesAutomatically: Bool, activityType: CLActivityType, isListeningForPositionUpdates: Bool,
                                 showBackgroundLocationIndicator: Bool, allowBackgroundLocationUpdates: Bool) {
        self.isListeningForPositionUpdates = isListeningForPositionUpdates
        locationManager.activityType = activityType
        locationManager.pausesLocationUpdatesAutomatically = pauseLocationUpdatesAutomatically
        locationManager.allowsBackgroundLocationUpdates = allowBackgroundLocationUpdates
        locationManager.showsBackgroundLocationIndicator = showBackgroundLocationIndicator
        
        locationManager.startMonitoringSignificantLocationChanges()
    }
}
