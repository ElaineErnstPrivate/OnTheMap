//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit
import MapKit
class AddLocationMapViewController: UIViewController , MKMapViewDelegate{
    let viewModel = StudentLocationsViewModel.shared

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    let annotation = MKPointAnnotation()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Add Location"
        let coordinate = CLLocationCoordinate2D(latitude: self.viewModel.annotation.coordinate.latitude, longitude: self.viewModel.annotation.coordinate.longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 0.25, longitudinalMeters: 0.25)
        mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(self.viewModel.annotation)
        // Do any additional setup after loading the view.
    }

    @IBAction func finish(_ sender: Any) {
        self.activityIndicator.startAnimating()
        if viewModel.isUpdating{
            self.viewModel.updateUserLocation { (success, error) in
                self.activityIndicator.stopAnimating()
                if let err = error{
                    self.displayAlert(message: err.description)
                }
                else{
                    self.dismiss()
                }
            }
        }else{
        viewModel.addNewLocation{ (success, error) in
            self.activityIndicator.stopAnimating()
            if let err = error{
                self.displayAlert(message: err.description)
            }
            else{
                self.dismiss()
                }
            }
        }
    }
    
    func dismiss(){
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)

    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

}
