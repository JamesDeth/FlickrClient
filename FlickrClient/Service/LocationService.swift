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

class LocationService: UIViewController, CLLocationManagerDelegate {
            
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        
        print("didFailWithError \(error.localizedDescription)")
    
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
            
        }
        self.lastLocationError = error
        self.stopLocationManager()
        
    }
    
    func locationManager(_ manager: CLLocationManager,   didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!

        if newLocation.timestamp.timeIntervalSinceNow < -5 { return }
        if newLocation.horizontalAccuracy < 0 { return  }
        if self.location == nil || self.location!.horizontalAccuracy > newLocation.horizontalAccuracy {

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
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }

    
    
    func getLocation() -> (Float?, Float?){
        if let location = location {
            return (Float(location.coordinate.latitude), Float(location.coordinate.longitude))

        } else {
                  
            let authStatus = CLLocationManager.authorizationStatus()
            if authStatus == .notDetermined {
              self.locationManager.requestWhenInUseAuthorization()
              return (nil, nil)
            }
            
            if authStatus == .denied || authStatus == .restricted {
              self.showAlert(title: "Location Services Disabled",
                             message: "Please enable location services for this app in Settings.")
              return (nil, nil)
            }
            
            self.startLocationManager()
            return (nil, nil)
            
            let statusTitle: String
            let statusMessage: String
            
            if let error = lastLocationError as NSError? {
              if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                statusTitle = "Location Services Disabled"
                statusMessage = "Please enable location services for this app in Settings."
              } else {
                statusTitle = "Something wrong"
                statusMessage = "Error Getting Location"
              }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusTitle = "Location Services Disabled"
                statusMessage = "Please enable location services for this app in Settings."
            } else if updatingLocation {
              statusTitle = "Searching..."
              statusMessage = "Please wait."
            } else {
                statusTitle = "Ready"
                statusMessage = "ready"
            }

            self.showAlert(title: statusTitle,
                           message: statusMessage)
            return (nil, nil)
        }
    }
    
    
}
