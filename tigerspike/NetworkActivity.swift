//
//  NetworkActivity.swift
//  tigerspike
//
//  Created by Mark Hoath on 4/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit

//  NAIM sets the spinning wheel in the top left of the phone to indicate Network Activity.
//  I have included a mechanism to pass closure functions which are queued and implemented
//  once the network operation has completed.
//  As there can be many async calls at one time, loadingCount keeps a track of how many
//  calls are outstanding. Completion Functions are called when there are no more networking
//  events outstanding.

class NetworkActivityIndicatorManager: NSObject {
    
    static let shared = NetworkActivityIndicatorManager()
    
    private var loadingCount = 0
    
    private static var functions: [()->Void] = []
    
    
    
    func networkOperationStarted(closure: @escaping()->Void) {
        
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
        NetworkActivityIndicatorManager.functions.append(closure)
    }
    
    func networkOperationFinished() {
        if loadingCount > 0 {
            loadingCount -= 1
        }
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            DispatchQueue.main.async {
                for function in NetworkActivityIndicatorManager.functions {
                    function()
                }
                NetworkActivityIndicatorManager.functions.removeAll()
            }
        }
    }
}

