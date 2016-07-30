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

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    //MARK: Properties
    
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var Coord: UILabel!
    @IBOutlet weak var QuickDial: UIButton!
    
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    var stickid: String = ""
    var sticktime: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
    
    //Mark: Actions
    
    @IBAction func QuickDial(sender: UIButton) {
        let phoneNumber = "90889548"
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    // Map location
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
      
        //poll stick location
        let url = NSURL(string: "http://188.166.241.24/retrieval.php")
        //var dataString:String = " "
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let dataString:String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            dispatch_async(dispatch_get_main_queue()) {
                // Update the UI on the main thread.
                
                self.Coord.text = dataString
                gpscoord = self.Coord.text!
                let newlineChars = NSCharacterSet.newlineCharacterSet()
                let gpscoordarr = gpscoord.utf16.split { newlineChars.characterIsMember($0) }.flatMap(String.init)
                lat = Double(gpscoordarr[1])!
                print(lat)
                long = Double(gpscoordarr[2])!
                print(long)
                self.stickid = String(UTF8String: gpscoordarr[0])!
                self.sticktime = String(UTF8String: gpscoordarr[3])!
                }
        }
        
        task.resume()
        
        let spanX = 0.007
        let spanY = 0.007
        let newRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: MKCoordinateSpanMake(spanX, spanY))
        
        theMap.setRegion(newRegion, animated: true)
        
        // show stick on map
        let stick = Stick(title: "James Tan",
                          locationName: "Stick ID:" + stickid,
                          discipline: sticktime,
                          coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
        
        theMap.addAnnotation(stick)
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 5 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            //remove marker updates new location every 5 sec
            self.theMap.removeAnnotation(stick)
        }
        
        //override func didReceiveMemoryWarning() {
         //   super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        //}
        let geocoder = CLGeocoder()
        let addrlocation = CLLocation(latitude: lat, longitude: long)
        
        geocoder.reverseGeocodeLocation(addrlocation) {
            
            (placemarks, error) -> Void in
            let placeArray = placemarks as [CLPlacemark]!
            var placeMark: CLPlacemark!
            
            placeMark = placeArray?[0]
            
            // Address dictionary
            //print(placeMark.addressDictionary)
        
            // Location name
            if let locationName = placeMark.addressDictionary?["Name"] as? NSString
            {
                print(locationName)
                self.Coord.text = String(locationName)
            }
        
            // Street address
            if let streetname = placeMark.addressDictionary?["Thoroughfare"] as? NSString
            {
                self.Coord.text = self.Coord.text! + "\n" + String(streetname)
            }
        
            // City
            if let cityname = placeMark.addressDictionary?["City"] as? NSString
            {
                self.Coord.text = self.Coord.text! + "\n" + String(cityname)
            }
        
        }
    
    }
}

    