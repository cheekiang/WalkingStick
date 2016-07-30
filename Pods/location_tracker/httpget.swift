//
//  httpget.swift
//  location_tracker
//
//  Created by Chee Kiang Tan on 23/7/16.
//  Copyright © 2016 Govtech. All rights reserved.
//

import Foundation
import XCPlayground

func httpGet(request: NSURLRequest, callback: (String?, NSError?) -> Void) {
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
        guard error == nil && data != nil else {
            callback(nil, error)
            return
        }
        
        callback(String(data: data!, encoding: NSUTF8StringEncoding), nil)
    }
    task.resume()
}

let request = NSMutableURLRequest(URL: NSURL(string: "http://www.google.com")!)

httpGet(request) { string, error in
    guard error == nil && string != nil else {
        print(error?.localizedDescription)
        return
    }
    
    print(string!)
}

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true