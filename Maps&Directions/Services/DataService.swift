//
//  DataService.swift
//  Maps&Directions
//
//  Created by vamsi krishna reddy kamjula on 10/17/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DataService {
    static let instance = DataService()
    
    var restaurantDetails = [Restaurant]()
    var contentArray = [String]()
    
    func dataService(urlString: String, completion: @escaping CompletionHandler) {
        let url = URL(string: urlString)
        self.restaurantDetails.removeAll()
        Alamofire.request(url!).responseJSON { (response) in
            if response.error != nil {
                completion(false)
                return
            }
            guard let json = JSON(response.result.value!).dictionary else {
                completion(false)
                return
            }
            guard let query = json["query"]?.dictionary else {
                completion(false)
                return
            }
            guard let results = query["results"]?.dictionaryValue else {
                completion(false)
                return
            }
            guard let result = results["Result"]?.arrayValue else {
                completion(false)
                return
            }
            for restaurant in result {
                let placeId = restaurant["id"].stringValue
                let placeTitle = restaurant["Title"].stringValue
                let placeAddress = restaurant["Address"].stringValue
                let placeCity = restaurant["City"].stringValue
                let placeState = restaurant["State"].stringValue
                let placePhone = restaurant["Phone"].stringValue
                let placeLatitude = restaurant["Latitude"].stringValue
                let placeLongitude = restaurant["Longitude"].stringValue
                let toDistance = restaurant["Distance"].stringValue
                let businessUrl = restaurant["BusinessUrl"].stringValue
                let rating = restaurant["Rating"].dictionary
                let placeRating = rating!["LastReviewIntro"]?.stringValue
                let categories = restaurant["Categories"].dictionaryValue
                guard let category = categories["Category"]?.arrayValue else {
                    completion(false)
                    return
                }
                self.contentArray.removeAll()
                for eachCategory in category {
                    let content = eachCategory["content"].stringValue
                    self.contentArray.append(content)
                }
                let details = Restaurant(id: placeId, title: placeTitle, address: placeAddress, city: placeCity, state: placeState, phone: placePhone, distance: toDistance, businessURL: businessUrl, latitude: placeLatitude, longitude: placeLongitude, rating: placeRating, category: self.contentArray)
                self.restaurantDetails.append(details)
            }
            completion(true)
        }
    }
}
