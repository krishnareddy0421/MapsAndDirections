//
//  PlaceCell.swift
//  Maps&Directions
//
//  Created by vamsi krishna reddy kamjula on 10/17/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var placeTitleLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var cityAndStateLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var toDistanceLbl: UILabel!
    
    func configureCell(_ placeInfo: Restaurant) {
        placeTitleLbl.text = placeInfo.title
        addressLbl.text = placeInfo.address
        cityAndStateLbl.text = "\(placeInfo.city!), \(placeInfo.state!)"
        phoneLbl.text = "Phone: \(placeInfo.phone!)"
        toDistanceLbl.text = "\(placeInfo.distance!) miles"
    }
}
