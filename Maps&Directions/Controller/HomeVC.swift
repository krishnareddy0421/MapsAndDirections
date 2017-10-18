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

class HomeVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchByZipView: UIView!
    @IBOutlet weak var zipcodeTextField: UITextField!
    
    var userLocation: UserLocation!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = self.tableView.frame.size.height / 2
        tableView.layer.cornerRadius = 7
        
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
        self.setupView()
    }

    func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemark, error) in
                if error != nil {
                    self.notAcquiringUserLocationAlert()
                    return
                }
                if let userPlace: CLPlacemark = placemark?[0] {
                    let userAddress = userPlace.thoroughfare
                    let userPostalCode = userPlace.postalCode
                    let userCountry = userPlace.country
                    let userLatitude = userPlace.location?.coordinate.latitude
                    let userLongitude = userPlace.location?.coordinate.longitude
                    
                    self.userLocation = UserLocation(address: userAddress!, postalCode: userPostalCode!, country: userCountry!, latitude: userLatitude!, longitude: userLongitude!)
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            self.locationDisabledErrorAlert()
        }
    }
    
    @IBAction func searchByZipBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.searchByZipView.alpha = 1
        }, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, searchBar.text != "" else {
            self.searchItemEmptyAlert()
            view.endEditing(true)
            return
        }
        view.endEditing(true)
        self.searchByFood(url: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20local.search%20where%20zip%3D%27\(userLocation.postalCode!)%27%20and%20query%3D%27\(searchTerm)%27&format=json&callback=")
        UIView.animate(withDuration: 0.8, animations: {
            self.tableView.alpha = 1
            self.tableView.center.y = self.view.frame.height - self.tableView.frame.size.height / 2
        }, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.center.y = self.view.frame.height * 20
        }, completion: nil)
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        zipcodeTextField.text = ""
        UIView.animate(withDuration: 0.3, animations: {
            self.searchByZipView.alpha = 0
        }, completion: nil)
        view.endEditing(true)
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        guard let zipcode = zipcodeTextField.text, zipcodeTextField.text != "" else {
            self.zipcodeEmptyAlert()
            view.endEditing(true)
            return
        }
        guard let searchTerm = searchBar.text, searchBar.text != "" else {
            self.searchItemEmptyAlert()
            view.endEditing(true)
            return
        }
        view.endEditing(true)
        UIView.animate(withDuration: 0.8, animations: {
            self.searchByZipView.alpha = 0
            self.tableView.alpha = 1
            self.tableView.center.y = self.view.frame.height - self.tableView.frame.size.height / 2
        }, completion: nil)
        self.searchByFood(url: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20local.search%20where%20zip%3D%27\(zipcode)%27%20and%20query%3D%27\(searchTerm)%27&format=json&callback=")
    }
    
    func searchByFood(url: String) {
        DataService.instance.dataService(urlString: url) { (success) in
            if success {
                self.tableView.reloadData()
            } else {
                self.somethingWentWrongAlert()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.restaurantDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PLACE_INFO_IDENTIFIER, for: indexPath) as? PlaceCell {
            let placeDetails = DataService.instance.restaurantDetails[indexPath.row]
            cell.configureCell(placeDetails, userLocation)
            
            let coordinate = CLLocationCoordinate2D.init(latitude: Double(placeDetails.latitude)!, longitude: Double(placeDetails.longitude)!)
            let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegionMake(coordinate, span)
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = placeDetails.title
            annotation.subtitle = """
            \(placeDetails.address!)
            \(placeDetails.city!), \(placeDetails.state!)
            """
            mapView.addAnnotation(annotation)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let placeDetails = DataService.instance.restaurantDetails[indexPath.row]
        let coordinate = CLLocationCoordinate2D.init(latitude: Double(placeDetails.latitude)!, longitude: Double(placeDetails.longitude)!)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
        let region = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated: true)
        
        let annotation = CustomAnnotation.init(title: placeDetails.title, coordinate: coordinate, subtitle: """
            \(placeDetails.address!)
            \(placeDetails.city!), \(placeDetails.state!)
            """, phoneNum: placeDetails.phone)
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
}

