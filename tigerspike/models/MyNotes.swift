//
//  MyNotes.swift
//  tigerspike
//
//  Created by Mark Hoath on 4/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit
import MapKit

class NoteAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

class MyNotes {
    static let shared = MyNotes()
    
    var notes: [Note] = []
    
    func clearNotes() {
        notes.removeAll()
    }
    
    func addNote(noteId:  String, name: String, note: String, coordinate: CLLocationCoordinate2D) {
        
        // Check to see if the Note is already in the list and if not add it.
        
        let empty = notes.filter({$0.noteId == noteId})
        if empty.count == 0 {
            let theNote = Note(noteId: noteId, name: name, note: note, coordinate: coordinate)
            notes.append(theNote)
        }
    }
    
    func deleteNote(noteId: String) {
        notes = notes.filter {$0.noteId != noteId}
    }
}

struct  Note {
    
    var noteId: String
    var name: String
    var note: String
    var coordinate: CLLocationCoordinate2D
}
