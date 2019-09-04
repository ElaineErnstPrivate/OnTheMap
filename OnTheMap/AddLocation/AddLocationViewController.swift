//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit
import CoreLocation
class AddLocationViewController: UIViewController, CLLocationManagerDelegate, NavigationConfigurable {
    let locationManager = CLLocationManager()
    let viewModel = StudentLocationsViewModel.shared

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addressString: UITextField!
    @IBOutlet weak var link: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()

    }
    @IBAction func cancel(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func findCurrentLocation(_ sender: Any) {
        // For use in foreground
        guard let address = addressString.text, let url = link.text else{
            return
        }
        if address.isEmpty || url.isEmpty{
            self.displayAlert(message: "Please enter address and URL")
            return
        }
        
        guard let urlInstance = URL(string: url) else{
            return
        }
        
        if !UIApplication.shared.canOpenURL(urlInstance){
            self.displayAlert(message: "Please enter a valid URL")
            return
        }
        viewModel.address = address
        viewModel.url = url
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "AddLocationMapViewController") else {
            return
        }
        self.activityIndicator.startAnimating()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(viewModel.address) { (placemark, error) in
        self.activityIndicator.stopAnimating()

            if let err = error {
                self.displayAlert(message: err.localizedDescription)
            }
            else{
                guard let place = placemark?.first , let coordinate = place.location?.coordinate else{
                    return
                }
                self.viewModel.annotation.coordinate =  coordinate
                self.viewModel.annotation.title = place.locality
                self.viewModel.annotation.subtitle = self.viewModel.url
                self.navigationController?.pushViewController(controller, animated: true)
                
            }
        }
    }
}
