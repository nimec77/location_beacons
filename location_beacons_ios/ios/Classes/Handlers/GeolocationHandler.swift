//
//  GeolocationHandler.swift
//  LocationBeaconsApp
//
//  Created by Dmitry Seloustev on 11.06.2024.
//

import Combine
import CoreLocation

typealias GeolocatorResult = CLLocation?
typealias GeolocatorError = (ErrorCodes, String)

class GeolocationHandler: NSObject, CLLocationManagerDelegate {
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        
        return manager
    }()
    
    private(set) var isListeningForPositionUpdates = false
    
    private(set) var errorHandler: GeolocatorError?
    
    private(set) var currentLocationResultHandler: GeolocatorResult = nil
    
    private(set) var listenerResultHandler: GeolocatorResult = nil
    
    func getLasKnownPosition() -> CLLocation? {
        return locationManager.location
    }
    
    func requestPosition(resultHandler: GeolocatorResult, errorHandler: GeolocatorError) {
        self.currentLocationResultHandler = resultHandler
        self.errorHandler = errorHandler
        
        var showBackgroundLocationIndicator = false
        var allowBackgroundLocationUpdates = false
        if (isListeningForPositionUpdates) {
            showBackgroundLocationIndicator = locationManager.showsBackgroundLocationIndicator
            allowBackgroundLocationUpdates = locationManager.allowsBackgroundLocationUpdates
        }
        startMonitoring(pauseLocationUpdatesAutomaticaly: false, activityType: CLActivityType.other , isListeningForPositionUpdates: isListeningForPositionUpdates, showBackgroundLocationIndicator: showBackgroundLocationIndicator, allowBackroundLocationUpdates: allowBackgroundLocationUpdates)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (listenerResultHandler == nil && currentLocationResultHandler == nil) {
            return
        }
        
        guard let location = locations.last else { return }
        
        if (currentLocationResultHandler != nil) {
            currentLocationResultHandler = location
        }
        if (listenerResultHandler != nil) {
            listenerResultHandler = location
        }
        
        
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
        
        errorHandler = (ErrorCodes.GeolocatorErrorLocationUpdateFailure, error.localizedDescription)
        currentLocationResultHandler = nil
        if (!isListeningForPositionUpdates) {
            stopMonitoring()
        }
    }
    
    private func stopMonitoring() {
        locationManager.stopMonitoringSignificantLocationChanges()
        isListeningForPositionUpdates = false
        errorHandler = nil
        listenerResultHandler = nil
    }
    
    private func startMonitoring(pauseLocationUpdatesAutomaticaly: Bool, activityType: CLActivityType, isListeningForPositionUpdates: Bool,
                                showBackgroundLocationIndicator: Bool, allowBackroundLocationUpdates: Bool) {
        self.isListeningForPositionUpdates = isListeningForPositionUpdates
        locationManager.activityType = activityType
        locationManager.pausesLocationUpdatesAutomatically = pauseLocationUpdatesAutomaticaly
        locationManager.allowsBackgroundLocationUpdates = allowBackroundLocationUpdates
        locationManager.showsBackgroundLocationIndicator = showBackgroundLocationIndicator
        
        locationManager.startMonitoringSignificantLocationChanges()
    }
}
