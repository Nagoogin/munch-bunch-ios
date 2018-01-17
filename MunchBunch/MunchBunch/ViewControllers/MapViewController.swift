//
//  MapViewController.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/15/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    // TODO: connect IBOutlet to MapViewController in storyboard
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    let regionRadius: CLLocationDistance = 2000
    
    let defaults = UserDefaults.standard
    
    var trucks: [Truck] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Initialize mapView, get nearby trucks, annotate mapView
        // TODO: Set to user's current location
        let initialLocation = CLLocation(latitude: 34.0224, longitude: -118.2851)
        centerMapOnLocation(location: initialLocation)
        
        if let token = defaults.object(forKey: "token") as? String {
            let authHeader = "Bearer " + token
            
            // Create auth header
            let headers: HTTPHeaders = [
                "Authorization":authHeader
            ]
            
            Alamofire.request(SERVER_URL + "trucks", method: .get, headers: headers).responseJSON {
                response in                
                // Parse trucks response
                switch response.result {
                case .success(let data):
                    print("Get trucks successful")
                    if let json = data as? [String : AnyObject] {
                        if let trucksJSON = json["data"] as? [[String : AnyObject]] {
                            // TODO: Get truck information
                            for i in 0..<trucksJSON.count {
                                let truck = trucksJSON[i]["name"] as! String
                                print(truck)
                                self.trucks = self.parseTrucks(trucksJSON: trucksJSON)
                                // Add truck annotations to mapView
                                self.addTrucksToMapView(trucks: self.trucks)
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseTrucks(trucksJSON: [[String : AnyObject]]) -> [Truck] {
        var trucks: [Truck] = []
        for i in 0..<trucksJSON.count {
            let id = trucksJSON[i]["id"] as! Int
            let name = trucksJSON[i]["name"] as! String
            let latitude = trucksJSON[i]["coordinate"]!["latitude"] as! Double
            let longitude = trucksJSON[i]["coordinate"]!["longitude"] as! Double
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let truck = Truck(id: id, name: name, coordinate: coordinate)
            trucks.append(truck)
        }
        return trucks
    }
    
    func addTrucksToMapView(trucks: [Truck]) {
        for i in 0..<trucks.count {
            mapView.addAnnotation(trucks[i])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        locationManager.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion (center:  location,span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
