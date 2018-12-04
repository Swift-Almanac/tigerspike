//
//  MyCoreLocation.swift
//  tigerspike
//
//  Created by Mark Hoath on 1/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

//      We keep a singleton for the current Location and Position to make things easier for us.

class MyCoreLocation {
    
    static let shared = MyCoreLocation()
    
    public private(set) var currentLocation: CLLocation
    public private(set) var currentPosition: CLLocationCoordinate2D
    public private(set) var lastLocation: CLLocation
    
    private init() {
        
        currentLocation = CLLocation(latitude: 0.0, longitude: 0.0)
        currentPosition = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        lastLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    }
    
    
    func setCurrentLocation(location: CLLocation) {
        lastLocation = currentLocation
        currentPosition = location.coordinate
        currentLocation = location
        
    }
}
