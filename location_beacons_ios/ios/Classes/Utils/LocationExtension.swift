//
//  LocationMapper.swift
//  LocationBeaconsApp
//
//  Created by Dmitry Seloustev on 18.06.2024.
//

import Foundation
import CoreLocation

extension CLLocation {
    var toDictionary: NSDictionary {
        var locationMap: [String: Any] = [:]
        
        locationMap["latitude"] = self.coordinate.latitude
        locationMap["longitude"] = self.coordinate.longitude
        locationMap["accuracy"] = self.horizontalAccuracy
        locationMap["timestamp"] = self.timestamp.currentTimeInMilliSeconds
        if (self.speed >= 0 && self.speedAccuracy >= 0) {
            locationMap["speed"] = self.speed
            locationMap["speed_accuracy"] = self.speedAccuracy
        }
        if (self.verticalAccuracy >= 0) {
            locationMap["altitude"] = self.altitude
            locationMap["altitude_accuracy"] = self.verticalAccuracy
        }
        locationMap["heading"] = self.course
        if #available(iOS 13.4, *) {
            locationMap["heading_accuracy"] = self.courseAccuracy
        }
        if #available(iOS 15.0, *) {
            locationMap["is_mocked"] = self.sourceInformation?.isSimulatedBySoftware ?? false
        }
        if (self.floor != nil && self.floor!.level != 0) {
            locationMap["floor"] = self.floor!.level
        }
        
        return locationMap as NSDictionary
    }
}
