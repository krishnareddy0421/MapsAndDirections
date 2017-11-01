//
//  PlaceCell.swift
//  Maps&Directions
//
//  Created by vamsi krishna reddy kamjula on 10/17/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

class PlaceCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var placeTitleBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var cityAndStateLbl: UILabel!
    @IBOutlet weak var toDistanceLbl: UILabel!
    @IBOutlet weak var phoneNumButton: UIButton!
    
    var sourceLocationCoordinates: CLLocationCoordinate2D!
    var destintionLocationCoordinates: CLLocationCoordinate2D!
    var mapView: MKMapView!
    
    var phoneNumBtnAttrs = [
        NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12.0),
        NSAttributedStringKey.foregroundColor : UIColor.red,
        NSAttributedStringKey.underlineStyle : 1
    ] as [NSAttributedStringKey : Any]
    
    func configureCell(_ placeInfo: Restaurant, _ userLocation: UserLocation, _ mapViewKit: MKMapView) {
        mapView = mapViewKit
        placeTitleBtn.setTitle(placeInfo.title!, for: .normal)
        
        addressLbl.text = placeInfo.address
        cityAndStateLbl.text = "\(placeInfo.city!), \(placeInfo.state!)"
        
        let phoneBtnTitle = NSMutableAttributedString(string:"Phone: \(placeInfo.phone!)", attributes: phoneNumBtnAttrs)
        let phoneAttributedString = NSMutableAttributedString(string:"")
        phoneAttributedString.append(phoneBtnTitle)
        phoneNumButton.setAttributedTitle(phoneAttributedString, for: .normal)
        
        let myLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let placeLocation = CLLocation(latitude: Double(placeInfo.latitude!)!, longitude: Double(placeInfo.longitude!)!)
        let distance = myLocation.distance(from: placeLocation)
        let distanceInMiles = Double(round(100*(distance/1609))/100)
        toDistanceLbl.text = "\(distanceInMiles) miles"
        let sourceCoordinates = CLLocationCoordinate2DMake(userLocation.latitude, userLocation.longitude)
        let destinationCoordinates = CLLocationCoordinate2DMake(Double(placeInfo.latitude!)!, Double(placeInfo.longitude!)!)

        sourceLocationCoordinates = sourceCoordinates
        destintionLocationCoordinates = destinationCoordinates
    }
    
    @IBAction func getDirectionBtnPressed(_ sender: Any) {
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocationCoordinates)
        let destinationPlacemark = MKPlacemark(coordinate: destintionLocationCoordinates)
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            let route = response?.routes[0]
            self.mapView.add((route?.polyline)!, level: .aboveRoads)
            let rectangle = route?.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rectangle!), animated: true)
        }
    }
    
    @IBAction func phoneNumberBtnPressed(_ sender: UIButton) {
        let phoneNum = sender.titleLabel?.text?.replacingOccurrences(of: "Phone: ", with: "")
        let filterPhoneNumber = removeSpecialCharsFromString(text: phoneNum!)
        guard let number = URL(string: "tel://" + filterPhoneNumber) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let chars : Set<Character> =
            Set("0123456789".characters)
        return String(text.characters.filter {chars.contains($0) })
    }
}
