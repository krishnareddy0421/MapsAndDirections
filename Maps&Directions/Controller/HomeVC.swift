//
//  ViewController.swift
//  Maps&Directions
//
//  Created by vamsi krishna reddy kamjula on 10/16/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class HomeVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var userLocation: UserLocation!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.search
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemark, error) in
                if error != nil {
                    // error handling
                    return
                }
                if let userPlace: CLPlacemark = placemark?[0] {
                    let userAddress = userPlace.thoroughfare
                    let userPostalCode = userPlace.postalCode
                    let userCountry = userPlace.country
                    let userLatitude = userPlace.location?.coordinate.longitude
                    let userLongitude = userPlace.location?.coordinate.longitude
                    
                    self.userLocation = UserLocation(address: userAddress!, postalCode: userPostalCode!, country: userCountry!, latitude: userLatitude!, longitude: userLongitude!)
                }
            })
            
//            let city: String!
//            let state: String!
//            let zipcode: Double!
//            let country: String!
//            let latitude: Double!
//            let longitude: Double!
//            let userCity = location.
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            self.locationDisabledErrorAlert()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, searchBar.text != "" else {
            // error handling
            return
        }
        view.endEditing(true)
        self.searchByFood(urlString: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20local.search%20where%20zip%3D%27\(userLocation.postalCode!)%27%20and%20query%3D%27\(searchTerm)%27&format=json&callback=")
    }
    
    func searchByFood(urlString: String) {
        print(urlString)
    }
}

