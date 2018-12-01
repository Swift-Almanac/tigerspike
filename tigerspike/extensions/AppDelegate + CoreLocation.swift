//
//  AppDelegate + CoreLocation.swift
//  tigerspike
//
//  Created by Mark Hoath on 1/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

let kMaxTimeAge: TimeInterval = 60.0

extension AppDelegate : CLLocationManagerDelegate {
    
    func initLocationServices() {
        locationManager.delegate = self
    }
    
    func startLocationServices() {
        //        print("Start Location Services")
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.activityType = .other
            locationManager.distanceFilter = kProduction ? 10.0 : kCLDistanceFilterNone
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func stopLocationServices() {
        //        print ("Stop Location Services")
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("Location Manager Error \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //        print ("Update Location")
        
        guard let newLocation = locations.last else {
            //            print ("Bad Location")
            return
        }
        
        let locationAge: TimeInterval = -(newLocation.timestamp.timeIntervalSinceNow)
        
        // If the age of the location is too old, ignore the update.
        
        if locationAge > kMaxTimeAge {
            //            print ("Location Update Too Old")
            return
        }
        
        // if Horizontal Accuracy is Bad then ignore the Coordinate
        
        if newLocation.horizontalAccuracy < 0 {
            //            print ("Invalid location accuracy. Rejected")
            return
        }
        
        if newLocation.horizontalAccuracy > 100.0 {
            //            print ("Horizontal Accuracy too Broad: \(newLocation.horizontalAccuracy)")
            return
        }
        
        // Now we have an accurate coordinate ! Save it to our Singleton for simplicity !
        
        MyCoreLocation.shared.setCurrentLocation(location: newLocation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        let topWindow = AppDelegate.topViewController()
        
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            // FIX User has selected In Use and we want Always On (so we can update play lists).
            startLocationServices()
            break
        case .authorizedAlways:
            // If always authorized
            startLocationServices()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            let alert = UIAlertController(title: "", message: "Your Device is Restricted and Can Not Use Location Services. You are unable to Use this App!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            topWindow?.present(alert, animated: true, completion: nil)
            break
        case .denied:
            
            let alert = UIAlertController(title: "Location Manager", message: "To Use This App, we need your Location!", preferredStyle: .alert)
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let settingAlertAction = UIAlertAction(title: "Settings", style: .default, handler: { (res) in
                
                if let url = URL(string:UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    }
                }
            })
            alert.addAction(cancelAlertAction)
            alert.addAction(settingAlertAction)
            
            topWindow?.present(alert, animated: true, completion: nil)
            
            break
        }
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
