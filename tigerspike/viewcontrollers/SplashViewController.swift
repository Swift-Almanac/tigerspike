//
//  ViewController.swift
//  tigerspike
//
//  Created by Mark Hoath on 1/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    let screenIV = UIImageView(frame: UIScreen.main.bounds)
    let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.style = UIActivityIndicatorView.Style.whiteLarge
        activity.color = .black
        
        view.backgroundColor = .black
        
        view.addSubview(screenIV)
        view.addSubview(activity)
        
        screenIV.image = UIImage(named: "tigerspike")
        screenIV.contentMode = .scaleAspectFit
        
        let activityCentreX = NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let activityCentreY = NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: -200)
        let activityHeight = NSLayoutConstraint(item: activity, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 100)
        let activityWidth = NSLayoutConstraint(item: activity, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 100)
        
        activity.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([activityCentreX, activityCentreY, activityHeight, activityWidth])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activity.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        activity.stopAnimating()
    }

}

