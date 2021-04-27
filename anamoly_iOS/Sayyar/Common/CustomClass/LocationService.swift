//
//  LocationService.swift
//  Imperfecto
//
//  Created by Atri Patel on 16/12/19.
//  Copyright © 2019 PCQ184. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
//import GoogleMaps
//import GooglePlaces


protocol LocationServiceDelegate: class {
    func didUpdateLocation(location: CLLocation)
}

protocol LocationServiceStatusDelegate: class {
    func didGrantPermission(_ isGranted: Bool)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    /// Core location
    private let locationManager: CLLocationManager =  CLLocationManager()

    weak var delegate: LocationServiceDelegate?
    weak var statusDelegate: LocationServiceStatusDelegate?
    private override init() {
    }
    
    static let shared: LocationService = {
        let instance = LocationService()
        return instance
    }()
    
    
    func askForLocationPermission() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation()  {
        locationManager.stopUpdatingLocation()
    }
    
     func isLocationDisableForMyAppOnly() -> Bool {
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .denied {
            return true
        }
        return false
    }
    
     func userLocationAvailable() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            // you're good to go!
            print("authorised")
            statusDelegate?.didGrantPermission(true)
        }
        
        if status == .authorizedWhenInUse {
            // you're good to go!
            print("authorised")
            statusDelegate?.didGrantPermission(true)
        }

        
        if (status == .denied || status == .notDetermined || status == .restricted)  {
            //Show start location
            statusDelegate?.didGrantPermission(false)
        }
        
        if (status == .denied || status == .notDetermined || status == .restricted)  {
            //Show start location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            delegate?.didUpdateLocation(location: location)
            print("New location is \(location)")
        }
    }
    
    func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                print("Something wrong with Location services")
                return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
    
}
