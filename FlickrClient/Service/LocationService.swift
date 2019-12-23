//
//  LocationService.swift
//  FlickrClient
//
//  Created by Tyts on 16.12.2019.
//  Copyright © 2019 Tyts&Co. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
            
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    var updatingLocation = false
    private var lastLocationError: Error?
    var latitude: Float? {
        if let latitude = self.location?.coordinate.latitude {
            return Float(latitude)
        } else {
            return nil
        }
    }
    var longitude: Float? {
        if let longitude = self.location?.coordinate.longitude {
            return Float(longitude)
        } else {
            return nil
        }
    }
    var statusMessage: String = ""
 
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        statusMessage = "didFailWithError \(error.localizedDescription)"
        if (error as NSError).code == CLError.locationUnknown.rawValue { return }
        self.lastLocationError = error
        self.stopLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        if newLocation.timestamp.timeIntervalSinceNow < -5 { return }
        if newLocation.horizontalAccuracy < 0 { return  }
        if self.location == nil {
            self.lastLocationError = nil
            self.location = newLocation
            if newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy {
                self.stopLocationManager()
            }
        }
    }

    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            self.updatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if self.updatingLocation {
            self.locationManager.stopUpdatingLocation()
            self.locationManager.delegate = nil
            self.updatingLocation = false
            self.location = nil
        }
    }

    func Error() -> Bool {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
            statusMessage = "Location Services Disabled"
            return false
        } else if let error = lastLocationError as NSError? {
            if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                statusMessage = "Location Services Disabled"
                return false
            } else {
                statusMessage = "Error Getting Location"
                return false
            }
        } else if !CLLocationManager.locationServicesEnabled() {
            statusMessage = "Location Services Disabled"
            return false
        }
        return true
    }
}
