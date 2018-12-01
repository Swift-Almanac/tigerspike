//
//  MyFirebase.swift
//  tigerspike
//
//  Created by Mark Hoath on 1/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class MyFirebase {
    
    static let shared = MyFirebase()
    
    var currentUser: User?
    var userId: String = ""
    var dbRef: DatabaseReference! = Database.database().reference()
    
    private var listenHandler: AuthStateDidChangeListenerHandle?
    
    
    /*  We cant use the init function as it would be called before FirebaseApp.configure() and would fail.
      Call initialize method immediately after FirebaseApp.configure in AppDelegate:didFinishLaunchingWIthOptions
    */
    
    func initialise() {
        if kProduction {    //  User the Production Database
            MyFirebase.shared.dbRef = Database.database(url: "https://tigerspike-production.firebaseio.com").reference()
            
        } else {    //  User the Default Development Database
            MyFirebase.shared.dbRef = Database.database().reference()
        }
    }
    
    
    /*  addUserListener, adds a listener for the User record and tells us if we are authorised or not.
        It is called once in
 
 
    */
    
    func addUserListener() {
        listenHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                
                // We are Logged Out of Firebase.
                self.currentUser = nil
                self.userId = ""
                
                //  Wait 3 Seconds and then move to Login Window.
                //  We Wait 3 seconds because in the startupcase we need time to actually see the
                //  SplashScreen.
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    moveToLoginWindow()
                }
            }
            else {
                
                // We are Logged In
                self.currentUser = user
                self.userId = (user?.uid)!
                
                //  Load Defaults from Local Persistent Storage.
                
                MyUser.shared.loadDefaults()
                
                //  Start Location Services
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.startLocationServices()
                
                //  Again allow 3 seconds before moving to the map window. This allows
                //  Core Location to get an accurate initial fix on the phone location.
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    moveToMapWindow()
                }
            }
        }
    }
    
    /*  removeUserListener() is called when the application terminates
        its probably unnecessary in our case.
    */
    
    func removeUserListener() {
        guard listenHandler != nil else {
            return
        }
        Auth.auth().removeStateDidChangeListener(listenHandler!)
    }
    
    // A successful call to LogOut will result in a response to the AuthListener above
    // which will redirect clients back to the LogIn Window.
    
    func logOut() {
        
        // Clean up anything here that needs to be done to Firebase prior to Signouts.
        //  eg Save / Write to the Firebase Database
        //  eg Close any listeners that are in use that rely upon privileged access.
        
        try? Auth.auth().signOut()
    }
    
    
    // Reset Password calls the Firebase Call to the email address supplied.
    
    func resetPassword(username: String) {
        Auth.auth().sendPasswordReset(withEmail: username, completion: nil)
    }
}
