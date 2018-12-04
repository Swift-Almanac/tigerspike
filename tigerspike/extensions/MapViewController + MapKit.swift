//
//  MapViewController + MapKit.swift
//  tigerspike
//
//  Created by Mark Hoath on 4/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        /* This is ONLY called while in foreground
         AND
         This is ONLY called if you have set showUserLocation to TRUE
         OR
         This is ONLY called if you have set TrackingMode to Follow with Heading.
         */
        
        // So we will use CoreLocation didUpdateLocation
    }
    
    //  isZooming Boolean, prevents redraws while a client is actively zooming the app.
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        isZooming = isMapZooming()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if isZooming {
            isZooming = false
        }
    }
    
    private func isMapZooming() -> Bool {
        let view = self.mapView.subviews[0]
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if recognizer.state == .began || recognizer.state == .ended {
                    return true
                }
            }
        }
        return false
    }
    
    //  AddNotes, adds the Annotations to the Map based on whether we are displaying all
    //  of the Notes or just a Searched Sub Set.
    
    func addNotes() {
        
        if !isSearching {                            //  We Aren't Searching
        
            for note in MyNotes.shared.notes {      //  So Draw All Notes
                mapView.addAnnotation(note)
            }
        } else {
            for note in MyNotes.shared.filtered {   //  We ARE Searching
                mapView.addAnnotation(note)         //  So Draw only Filtered List
            }
        }
    }
    
    //  Removes All Annotations from the Map, Called prior to addNotes above to ensure
    //  we start with a clean slate.
    
    func clearNotes() {
        
        // Remove all of the Annotations
        
        mapView.removeAnnotations(mapView.annotations)
        
    }
    
    //  Refresh Notes is called as a result of either a Database Update (multiuser access) or
    //  Changes to Search Criteria on the Map
    
    func refreshNotes() {
        clearNotes()
        addNotes()
    }
    
    //  Using the Map Kit Protocol, we need to Draw our Annotations in response to a Map Update.
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Do Nothing if the annotation is the Users Location annotation
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let identifier = "Note Annotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as MKAnnotationView?
        
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
}








