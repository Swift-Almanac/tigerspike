//
//  MapViewController.swift
//  tigerspike
//
//  Created by Mark Hoath on 1/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit
import MapKit

fileprivate let kSearchBarHeight: Int = 40

class MapViewController: UIViewController {

    let mapView = MKMapView(frame: UIScreen.main.bounds)
    
    var mapDiameter: CLLocationDistance = 200.0 // in Meters.
    var isZooming: Bool = false
    
    var isSearching: Bool = false
    
    var searchOn: Int = 0
    
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: kSearchBarHeight))
    let segmented = UISegmentedControl(frame: CGRect(x: 0, y: 56, width: Int(UIScreen.main.bounds.width), height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Map"
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        navigationItem.leftBarButtonItem = logoutButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        navigationItem.rightBarButtonItem = addButton
        
        segmented.backgroundColor = .white
        segmented.insertSegment(withTitle: "All", at: 0, animated: false)
        segmented.insertSegment(withTitle: "Name", at: 1, animated: false)
        segmented.insertSegment(withTitle: "Note", at: 2, animated: false)
        segmented.selectedSegmentIndex = 0
        
        segmented.addTarget(self, action: #selector(searchChanged), for: .valueChanged)
        
        searchBar.sizeToFit()
        
        view.addSubview(mapView)
        view.addSubview(searchBar)
        view.addSubview(segmented)
        
        mapView.delegate = self
        searchBar.delegate = self
        
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
    
    //  Centres the Map on the current User Location.
    
    func centerMap() {
        
        let coordRegion = MKCoordinateRegion(center: MyCoreLocation.shared.currentPosition, latitudinalMeters: mapDiameter, longitudinalMeters: mapDiameter)
        mapView.setRegion(coordRegion, animated: true)
    }
    
    //  When we close the map, set the searchBar text to nil
    
    override func viewDidDisappear(_ animated: Bool) {
        searchBar.text = ""
    }
    
    //   Called from the menu '+' sign. Add Item asks for a Note to associate with the location (Mandatory) then
    //   Saves it to Firebase and causes a refresh of all the Annotations so the new note is drawn.
    
    @objc func addItem() {
        
        // Add an Alert to capture Notes
        
        let alert = UIAlertController(title: "Notes", message: "Add a note for this location", preferredStyle: .alert)
        
        alert.addTextField {(textField) in
            textField.placeholder = "Notes"}
        
        let acceptAction = UIAlertAction(title: "OK", style: .default, handler: { [weak alert](_) in
            guard let userField = alert?.textFields?[0] else {
                return
            }
            
            guard let theNote = userField.text else {
                return
            }
            
            if !theNote.isEmpty {
                MyFirebase.shared.saveNote(name: MyUser.shared.name, note: theNote, coordinate: MyCoreLocation.shared.currentPosition)

            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(acceptAction)
        
        self.present(alert, animated: true, completion: nil)

    }
    
    //  Called in relation to the Bar Button Item text LOGOUT.
    
    @objc func logout() {
        MyFirebase.shared.logOut()
    }
    
    //  Set up Contraints for the Controls on the View.
    
    func setUpConstraints() {
        
        let mapTop = NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        let mapLeft = NSLayoutConstraint(item: mapView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0)
        let mapBottom = NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view , attribute: .bottom, multiplier: 1.0, constant: 0)
        let mapRight = NSLayoutConstraint(item: mapView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([mapTop, mapLeft, mapBottom, mapRight])
    }
        
}
