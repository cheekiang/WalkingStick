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
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
           let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                regionRadius * 2.0, regionRadius * 2.0)
           theMap.setRegion(coordinateRegion, animated: true)
        }
        //Set accuracy
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        //manager.requestAlwaysAuthorization()
        //manager.startUpdatingLocation()
    
        //Setup Map View
        theMap.delegate = self
        theMap.mapType = MKMapType.Standard
        theMap.showsUserLocation = true
        centerMapOnLocation(initialLocation)
        
        // show stick on map
        let stick = Stick(title: "James Tan",
                              locationName: "Hougang",
                              discipline: "Walking Stick",
                              coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        
        theMap.addAnnotation(stick)
        
        let url = NSURL(string: "http://188.166.241.24/retrieval.php")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
           print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        //Coord.text = emptystring
        task.resume()
        
}
    
    
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
      
        myLocations.append(locations[0] )
      
        let spanX = 0.007
        let spanY = 0.007
        let newRegion = MKCoordinateRegion(center: theMap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        
        theMap.setRegion(newRegion, animated: true)
        
        if (myLocations.count > 1){
            
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            
            var a = [c1, c2]
            
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            theMap.addOverlay(polyline)
            
        }
    }
         
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

    