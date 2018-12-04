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
    
    func addNotes() {
        
        for note in MyNotes.shared.notes {
            let note = NoteAnnotation(title: MyUser.shared.name, subtitle: note.note, coordinate: note.coordinate)
            mapView.addAnnotation(note)
        }
    }
    
    func clearNotes() {
        
        // Get a copy of the User Location (which is an annotation)
        
        let userLocation = mapView.userLocation
        
        // Remove all of the Annotations
        
        mapView.removeAnnotations(mapView.annotations)
        
        // Add the User Location back in
        
        if userLocation != nil {
            mapView.addAnnotation(userLocation)
        }
    }
    
    func refreshNotes() {
        clearNotes()
        addNotes()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Do Nothing if the annotation is the Users Location annotation
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        if annotation.isKind(of: NoteAnnotation.self) {
            let identifier = "Note Annotation"
//            let note = annotation as! NoteAnnotation
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as MKAnnotationView?
            
            if annotationView == nil {
                
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
    return nil
    }
    
}








