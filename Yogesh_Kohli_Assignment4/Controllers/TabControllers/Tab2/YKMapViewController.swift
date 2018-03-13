//
//  YKMapViewController.swift
//  Yogesh_Kohli_Assignment4
//
//  Created by Yogesh Kohli on 10/11/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class YKMapViewController: YKBaseViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var buttonGetDirections: YKButtonCustomClass!
    @IBOutlet weak var textFieldFrom: YKTextFieldCustomClass!
    @IBOutlet weak var textFieldTo: YKTextFieldCustomClass!
    
    let locationManager = CLLocationManager()
    var source: MKMapItem?
    var locationArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customiseUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUserLocation()
        //SAN DIEGO COORDINATES
        self.zoomMap(latitude: 32.715736, longitude: -117.161087)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mapView.showsUserLocation = false
        locationManager.stopUpdatingLocation()
    }
    //To Hide Keyboard on touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textFieldFrom {
            textFieldTo.becomeFirstResponder()
        }
        else {
            textFieldTo.resignFirstResponder()
        }
    }
    
    //MARK: Private Methods
    //Method to add pin to the map
    func addPinToMap(location : CLLocationCoordinate2D, title: String?, subtitle:String?) {
        DispatchQueue.main.async {
            let newPin = MKPointAnnotation()
            newPin.coordinate = location
            newPin.title = title
            newPin.subtitle = subtitle
            self.mapView.addAnnotation(newPin)
        }
    }
    //To clear any overlays or pins
    func clearMap() {
        mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.overlays.forEach {
            self.mapView.remove($0)
        }
    }
    //To convert address/string to latitude-longitude
    func addressToCoordinatesConverter(address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address as String, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let annotation = MKPlacemark(placemark: placemarks.first!)
                    print(self.locationArray)
                    print(address)
                    self.locationArray.add(annotation.coordinate.latitude)
                    self.locationArray.add(annotation.coordinate.longitude)
                    if self.locationArray.count != 0 && address == self.textFieldFrom.text! {
                        self.addPinToMap(location: annotation.coordinate, title: address, subtitle: "Starting Location!")
                    }
                    else if self.locationArray.count != 0 && address == self.textFieldTo.text! {
                        self.addPinToMap(location: annotation.coordinate, title: address, subtitle: "Destination Location!")
                    }
                    
                    print(self.locationArray)
                    
                    if self.locationArray.count == 4 {
                        self.getDirections()
                    }
                }
            }
        })
    }
    //getting values of textfields
    func getFromTextField() -> String? {
        return self.textFieldFrom.text
    }
    func getToTextField() -> String? {
        return self.textFieldTo.text
    }
    func customiseUI() -> Void {
        self.viewBackground.backgroundColor = UIColor.clear
    }
    //Showing route in the map
    func showRoute(_ response: MKDirectionsResponse, source:MKMapItem?) {
        DispatchQueue.main.async {
            for route in response.routes {
                self.mapView.add(route.polyline,
                                 level: MKOverlayLevel.aboveRoads)
                
                for step in route.steps {
                    print(step.instructions)
                }
            }
            let span = MKCoordinateSpanMake(0.0175, 0.0175)
            let region = MKCoordinateRegionMake((source?.placemark.coordinate)!, span)
            self.mapView.setRegion(region, animated: true)
        }
    }
    //Rendering - stroke color, width
    func mapView(_ mapView: MKMapView, rendererFor
        overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    //Getting directions between source and request
    func getDirections() {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locationArray[0] as! CLLocationDegrees, longitude: locationArray[1] as! CLLocationDegrees), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locationArray[2] as! CLLocationDegrees, longitude: locationArray[3] as! CLLocationDegrees), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: {(response, error) in
            if error != nil {
                self.alertMessage("Error getting direction. Please enter valid location!!")
            } else {
                self.showRoute(response!,source: request.destination)
            }
        })
    }
   
    
    //MARK: LOCATION MANAGER
    func zoomMap(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        DispatchQueue.main.async {
            self.mapView.delegate = self
            var noLocation = CLLocationCoordinate2D()
            noLocation.latitude = latitude
            noLocation.longitude = longitude
            let span = MKCoordinateSpanMake(0.825, 0.825)
            let region = MKCoordinateRegionMake(noLocation, span)
            self.mapView.setRegion(region, animated: true)
        }
    }
    //Setting user location
    func setUserLocation() {
        self.mapView.showsUserLocation = true
            // For use in foreground
            locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.clearMap()
            let location = locations.last! as CLLocation
            self.addPinToMap(location: location.coordinate, title: "Current Location!", subtitle: "My Location!! Yayy!!")
            self.zoomMap(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //MARK: UIButton Actions
    @IBAction func buttonGetDirectionsPressed(_ sender: Any) {
        if getFromTextField()?.count != 0 && getToTextField()?.count != 0{
            self.locationArray.removeAllObjects()
            clearMap()
            setUserLocation()
            self.addressToCoordinatesConverter(address: self.textFieldFrom.text!)
            self.addressToCoordinatesConverter(address: self.textFieldTo.text!)
        }
        else {
            let message = "Location cannot be empty! Please enter some valid location!"
            alertMessage(message)
        }
    }
}
//Code to check whether app is executed in simulator or physical device
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

