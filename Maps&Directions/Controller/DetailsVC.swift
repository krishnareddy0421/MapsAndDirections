//
//  DetailsVC.swift
//  Maps&Directions
//
//  Created by vamsi krishna reddy kamjula on 11/1/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var websiteWebView: UIWebView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    var placeInfo: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        self.loadWebPage()
    }
    
    func loadWebPage() {
        let url = URL.init(string: placeInfo!.businessURL)
        let request = URLRequest(url: url!)
        websiteWebView.loadRequest(request)
        activitySpinner.isHidden = true
        activitySpinner.stopAnimating()
    }
}
