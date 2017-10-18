//
//  CustomAnnotation.swift
//  Maps&Directions
//
//  Created by vamsi krishna reddy kamjula on 10/17/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import Foundation
import MapKit


class CustomAnnotation: NSObject, MKAnnotation{
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let subtitle: String?
    let phoneNum: String?
    
    init(title: String?, coordinate: CLLocationCoordinate2D, subtitle: String, phoneNum: String?){
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
        self.phoneNum = phoneNum
        
        super.init()
    }
}

