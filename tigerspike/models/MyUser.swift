//
//  MyUser.swift
//  tigerspike
//
//  Created by Mark Hoath on 1/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit

//   Internal Singleton for our User Information (Name and Email Address).
//   We also save the username to UserDefaults so that we can prepopulate the UserName on the
//  login screen if needed.

class MyUser {
    
    static let shared = MyUser()
    
    var username: String = ""       //  An Email Address
    var name: String = ""           //  Name used as a Label on Map


    func loadDefaults() {
        username = UserDefaults.standard.string(forKey: "username") ?? ""
    }
    
    func saveDefaults() {
        UserDefaults.standard.set(username, forKey: "username")
    }

}
