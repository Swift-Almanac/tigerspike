//
//  MyNotes.swift
//  tigerspike
//
//  Created by Mark Hoath on 4/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit
import MapKit

//  NoteAnnotation conformes to the MKAnnotation protocal and we link this to the noteId for each note record.
//  The title is the Name of the Client (or Person Saving the note) and the subtitle is the Note for the location.

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

// My Notes contains 2 arrays of Notes. A complete list from the Firebase Database and a subset that is calculated
// based on search criteria if used. (otherwise its empty)
// The Added the noteID from Firebase in case we developed a Delete feature and also to allow use to remove deplicates in the
// "All" search as records could hit for both Name and Note searches.

class MyNotes {
    
    static let shared = MyNotes()
    
    var notes: [NoteAnnotation] = []
    var filtered: [NoteAnnotation] = []
    
    // Clear Notes is called to empty the 2 lists prior to adding notes.
    
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
    
    func filterNotes(filter: String, category: Int) {
        
        filtered.removeAll(keepingCapacity: false)
        
        //      Names and Notes Filtering
        
        if category == 0 {
            
//          Filter for both Names and Notes
            
            let temp1 = notes.filter( {$0.title?.range(of: filter) != nil})
            let temp2 = notes.filter( {$0.subtitle?.range(of: filter) != nil})
            
            // Set set the filtered list to the Names list
            filtered = temp1
            
            // Iterated Through all the notes and add them if they dont have the same noteId.
            
            for item in temp2 {
                if filtered.filter( {$0.noteId == item.noteId}).isEmpty {
                    filtered.append(item)
                } else {
//                    print("ignored duplicate")
                }
            }
            
        } else if category == 1 {
            
            //  Names Only filtering
            
            filtered = notes.filter( {$0.title?.range(of: filter) != nil})
        } else if category == 2 {
            
            // Notes Only Filtering.
            
            filtered = notes.filter( {$0.subtitle?.range(of: filter) != nil})
        } else {
            print ("This shouldn't happen")
        }
    }
}
