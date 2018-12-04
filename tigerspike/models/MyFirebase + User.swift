//
//  MyFirebase + User.swift
//  tigerspike
//
//  Created by Mark Hoath on 1/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import Firebase
import CoreLocation

extension MyFirebase {
    
    func loadUser() {
        
        dbRef.child("user").child(userId).child("info").observeSingleEvent(of: .value, with:  { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                return
            }
            
            let username = value["username"] as? String ?? ""
            let name = value["name"] as? String ?? ""
            
            MyUser.shared.username = username
            MyUser.shared.name = name
            
        })
        
    }
    
    func saveUser() {
        
        let data = [ "username": MyUser.shared.username,
                     "name" : MyUser.shared.name
            ] as [String: Any]
        
        dbRef.child("user").child(userId).child("info").setValue(data)
                
    }
    
    func loadNotes() {
        
        dbRef.child("notes").observeSingleEvent(of: .value, with:  { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else {
                return
            }
            
            MyNotes.shared.clearNotes()
            
            for note in value {
                let dictionary = note.value as! NSDictionary
                let noteId = dictionary["noteId"] as? String ?? ""
                let name = dictionary["name"] as? String ?? ""
                let note = dictionary["note"] as? String ?? ""
                let lat = dictionary["lat"] as? Double ?? 0.0
                let lon = dictionary["lon"] as? Double ?? 0.0
                
                if noteId.isEmpty || name.isEmpty || note.isEmpty || lat == 0.0 || lon == 0.0 {
                    print ("Bad Record")
                    return
                }
                
                MyNotes.shared.addNote(noteId: noteId, name: name, note: note, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon) )
            }
            
            let username = value["username"] as? String ?? ""
            let name = value["name"] as? String ?? ""
            
            MyUser.shared.username = username
            MyUser.shared.name = name
        
            let vc = AppDelegate.topViewController()
            if vc is MapViewController {
                let theVC = vc as! MapViewController
                theVC.refreshNotes()
            }
        })

    }
    
    func saveNote(name: String, note: String, coordinate: CLLocationCoordinate2D ) {
        
        let noteId = dbRef.child("notes").childByAutoId().key!
        
        let data = [ "noteId" : noteId,
                     "name" : name,
                     "note" : note,
                     "lat" : coordinate.latitude,
                     "lon" : coordinate.longitude
        ] as [String: Any]
        
        dbRef.child("notes").childByAutoId().setValue(data)
        loadNotes()
    }
    
}
