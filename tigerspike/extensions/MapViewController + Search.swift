//
//  MapViewController + Search.swift
//  tigerspike
//
//  Created by Mark Hoath on 4/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit

extension MapViewController : UISearchBarDelegate {
    
    //  searchChanged is called in response to the SegmentedControl valueChanged (from All, Name or Notes)
    
    @objc func searchChanged(segmentedControl: UISegmentedControl) {
        
        searchOn = segmentedControl.selectedSegmentIndex
        let searchPredicate = searchBar.text!
        isSearching = (searchPredicate.count == 0) ? false: true
        MyNotes.shared.filterNotes(filter: searchPredicate, category: searchOn)
        refreshNotes()
        
    }
    
    //  searchBar:TextDidChange is called in response to clients entering text in the Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchPredicate = searchBar.text!
        isSearching = (searchPredicate.count == 0) ? false: true
        MyNotes.shared.filterNotes(filter: searchPredicate, category: searchOn)
        refreshNotes()
        
    }
        
}
