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
    
    var noteId: String = ""
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(noteId: String, title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.noteId = noteId
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

class MyNotes {
    static let shared = MyNotes()
    
    var notes: [NoteAnnotation] = []
    var filtered: [NoteAnnotation] = []
    
    func clearNotes() {
        filtered.removeAll()
        notes.removeAll()
    }
    
    func addNote(noteId:  String, name: String, note: String, coordinate: CLLocationCoordinate2D) {
        
        // Check to see if the Note is already in the list and if not add it.
        
        let empty = notes.filter({$0.noteId == noteId})
        if empty.count == 0 {
            let theNote = NoteAnnotation(noteId: noteId, title: name, subtitle: note, coordinate: coordinate)
            notes.append(theNote)
        }
    }
    
    func deleteNote(noteId: String) {
        notes = notes.filter {$0.noteId != noteId}
    }
    
    func filterNotes(filter: String) {
        
        filtered.removeAll(keepingCapacity: false)
        filtered = notes.filter( {$0.title?.range(of: filter) != nil})

    }
}
