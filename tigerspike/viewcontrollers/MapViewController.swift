//
//  MapViewController.swift
//  tigerspike
//
//  Created by Mark Hoath on 1/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    let mapView = MKMapView(frame: UIScreen.main.bounds)
    
    var mapDiameter: CLLocationDistance = 200.0 // in Meters.
    var isZooming: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Map"
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        navigationItem.leftBarButtonItem = logoutButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(mapView)
        
        mapView.delegate = self
        
        mapView.mapType = .standard
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.isUserInteractionEnabled = true
        mapView.userTrackingMode = .followWithHeading
        

        view.backgroundColor = .white
        setUpConstraints()
        
        centerMap()
        
        addNotes()

    }
    
    func centerMap() {
        
        let coordRegion = MKCoordinateRegion(center: MyCoreLocation.shared.currentPosition, latitudinalMeters: mapDiameter, longitudinalMeters: mapDiameter)
        mapView.setRegion(coordRegion, animated: true)
    }
    
    @objc func addItem() {
        print ("Add Item")
        
        // Add an Alert to capture Notes
        
        let note = "I am Here"
        
        // Save to Firebase ... Save to Firebase will then LoadFirebase Database as we need the noteID calculated.
        
        MyFirebase.shared.saveNote(name: MyUser.shared.name, note: note, coordinate: MyCoreLocation.shared.currentPosition)
    }
    
    @objc func logout() {
        MyFirebase.shared.logOut()
    }
    
    func setUpConstraints() {
        
        let mapTop = NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        let mapLeft = NSLayoutConstraint(item: mapView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0)
        let mapBottom = NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view , attribute: .bottom, multiplier: 1.0, constant: 0)
        let mapRight = NSLayoutConstraint(item: mapView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([mapTop, mapLeft, mapBottom, mapRight])
    }
        
}
