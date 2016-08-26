//
//  Stick.swift
//  location_tracker
//
//  Created by Chee Kiang Tan on 23/7/16.
//  Copyright © 2016 Govtech. All rights reserved.
//

import Foundation
import MapKit

class Stick: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let sticktiming: CLongLong
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, sticktiming: CLongLong, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.sticktiming = sticktiming
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}