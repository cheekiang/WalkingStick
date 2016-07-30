//
//  httppoll.swift
//  location_tracker
//
//  Created by Chee Kiang Tan on 23/7/16.
//  Copyright © 2016 Govtech. All rights reserved.
//
import Foundation

func HTTPsendRequest(request: NSMutableURLRequest,callback: (String, String?) -> Void) {
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request,completionHandler :
        {
            data, response, error in
            if error != nil {
                callback("", (error!.localizedDescription) as String)
            } else {
                callback(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String,nil)
            }
    })
    
    //task!.resume() //Tasks are called with .resume()
    
}

func HTTPGet(url: String, callback: (String, String?) -> Void) {
    let request = NSMutableURLRequest(URL: NSURL(string: url)!) //To get the URL of the receiver , var URL: NSURL? is used
    HTTPsendRequest(request, callback: callback)
}


HTTPGet("http://188.166.241.24/retrieval.php") {
    (data: String, error: String?) -> Void in
    if error != nil {
        print(error)
    } else {
        //print("data is : \n\n\n")
        emptystring = data
    }
    
}
