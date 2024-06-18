//
//  DateExtension.swift
//  LocationBeaconsApp
//
//  Created by Dmitry Seloustev on 18.06.2024.
//

import Foundation

extension Date {
    var currentTimeInMilliSeconds: Double {
        self.timeIntervalSince1970 * 1000;
    }
}
