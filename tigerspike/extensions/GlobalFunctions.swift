//
//  GlobalFunctions.swift
//  tigerspike
//
//  Created by Mark Hoath on 1/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit

// Global Variables

let kProduction: Bool = false       //  Set to True for Production Builds

let kBundleID: String = Bundle.main.bundleIdentifier!   //  The Bundle Identifier String (non-optional)



//   Global Functions

//  As Firebase Login could be cancelled by client on another device, or through Facebook/Google sites
//  if those Auth methods are used. A Logout Call could happen anywhere and so this function is global.

func moveToLoginWindow() {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
    appDelegate.window?.makeKeyAndVisible()
    appDelegate.window?.rootViewController = LoginViewController()
}

//  for consistancy the navigation to the top of the Navigation Controller is also global. This is because
// the call could be made either as a result of a sucessful Login or as a result of a restart where login is
// persistent

func moveToMapWindow() {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
    appDelegate.window?.makeKeyAndVisible()
    let navController = UINavigationController(rootViewController: MapViewController())
    appDelegate.window?.rootViewController = navController
}

// for consistency the splash screen instantiation is also a globel function, even though it should only even
//  be called on startup (and once)

func moveToSplashScreen() {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
    appDelegate.window?.makeKeyAndVisible()
    appDelegate.window?.rootViewController = SplashViewController()
}

// doNothing does just that! It is called by the NetworkActivity when there is a nil completion routine.
// Due to a "bug" in Swift, its not possible to pass nil to an @escaping function (ie an optional) so we
// always need to pass a function, in the case where we should be passing nil, we pass doNothing() !

func doNothing() {
    
}

