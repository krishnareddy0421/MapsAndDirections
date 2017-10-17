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
}
