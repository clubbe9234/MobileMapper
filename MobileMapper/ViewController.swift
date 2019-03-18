//
//  ViewController.swift
//  MobileMapper
//
//  Created by Caroline Lubbe on 3/6/19.
//  Copyright © 2019 John Hersey High School. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var parks: [MKMapItem] = []
    var initialRegion: MKCoordinateRegion!
    var isInitialMapLoad = true
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if isInitialMapLoad {
            initialRegion = MKCoordinateRegion(center: mapView.centerCoordinate, span: mapView.region.span)
            isInitialMapLoad = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(mapView.userLocation) {
            return nil
        } else {
            let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(named: "tree")
            pin.canShowCallout = true
            let buttonOne = UIButton(type: .detailDisclosure)
            pin.rightCalloutAccessoryView = buttonOne
            let buttonTwo = UIButton(type: .contactAdd)
            pin.leftCalloutAccessoryView = buttonTwo
            return pin
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let buttonPressed = control as! UIButton
        var currentMapItem = MKMapItem()
        if let title = view.annotation?.title, let parkName = title {
            for mapItem in parks {
                if mapItem.name == parkName {
                    currentMapItem = mapItem
                }
            }
        }
        if buttonPressed.buttonType == .contactAdd {
            if let url = currentMapItem.url {
                let svc = SFSafariViewController(url: url)
                present(svc, animated: true, completion: nil)
                
            }
        } else {
            var description = ""
            if let phoneNumber = currentMapItem.phoneNumber {
                description += "Phone number: \(phoneNumber) "
            }
            guard let addressNumber = currentMapItem.placemark.subThoroughfare, let addressStreet = currentMapItem.placemark.thoroughfare else {
                return
            }
            description += "Address: \(addressNumber) \(addressStreet) "
            let alert = UIAlertController(title: "More Info", message: description, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
    @IBAction func whenZoomButtonPressed(_ sender: Any) {
        let center = currentLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func whenSearchButtonPressed(_ sender: Any) {
        let center = currentLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Parks"
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                return
            }
            for mapItem in response.mapItems {
                self.parks.append(mapItem)
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
                
            }
        }
    }
}

