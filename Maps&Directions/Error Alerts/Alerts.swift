//
//  Alerts.swift
//  Maps&Directions
//
//  Created by vamsi krishna reddy kamjula on 10/17/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit

extension UIViewController {
    func locationDisabledErrorAlert() {
        let alert = UIAlertController.init(title: "Location Access Disabled", message: "Need User Location to Search", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func somethingWentWrongAlert() {
        let alert = UIAlertController.init(title: "Something Went Wrong !!!", message: "Try Again", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func searchItemEmptyAlert() {
        let alert = UIAlertController.init(title: "Enter Food Item !", message: "Try Again", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func notAcquiringUserLocationAlert() {
        let alert = UIAlertController.init(title: "Something Wrong With Location Services !!!", message: "Try Again", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func zipcodeEmptyAlert() {
        let alert = UIAlertController.init(title: "Enter Proper Zipcode !", message: "Try Again", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
