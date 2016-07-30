//
//  ViewController.swift
//  location_tracker
//
//  Created by Chee Kiang Tan on 21/7/16.
//  Copyright © 2016 Govtech. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
var gpscoord : String = String()
var lat: Double = 0.0
var long: Double = 0.0
var currentsticktime: CLongLong = 0

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var Coord: UILabel!
   
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Setup Location Manager
        //responsible to know where the device is
        manager = CLLocationManager()
        manager.delegate = self
        
        //init location
        let initialLocation = CLLocation(latitude: lat, longitude: long)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
           let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                regionRadius * 2.0, regionRadius * 2.0)
           theMap.setRegion(coordinateRegion, animated: true)
        }
        //Set accuracy
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        //manager.requestAlwaysAuthorization()
        
        //calls update function
        manager.startUpdatingLocation()
    
        //Setup Map View
        theMap.delegate = self
        theMap.mapType = MKMapType.Standard
        //theMap.showsUserLocation = true
        centerMapOnLocation(initialLocation)
     
        
}
    
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
      
        //myLocations.append(locations[0] )
        //poll stick location         
        let url = NSURL(string: "http://188.166.241.24/retrieval.php")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let dataString:String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            dispatch_async(dispatch_get_main_queue()) {
                // Update the UI on the main thread.
                
                self.Coord.text = dataString
                gpscoord = self.Coord.text!
                let newlineChars = NSCharacterSet.newlineCharacterSet()
                let gpscoordarr = gpscoord.utf16.split { newlineChars.characterIsMember($0) }.flatMap(String.init)
                lat = Double(gpscoordarr[1])!
                long = Double(gpscoordarr[2])!
                currentsticktime = CLongLong(gpscoordarr[3])!
                }
        }
        
        task.resume()
        
        let spanX = 0.007
        let spanY = 0.007
        let newRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: MKCoordinateSpanMake(spanX, spanY))
        
        theMap.setRegion(newRegion, animated: true)
        
        
        // show stick on map
        let stick = Stick(title: "James Tan",
                          locationName: "Walking Stick: 0002",
                          sticktiming: currentsticktime,
                          coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
        
        theMap.addAnnotation(stick)
        theMap.removeAnnotation(stick)
    }
         
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

    