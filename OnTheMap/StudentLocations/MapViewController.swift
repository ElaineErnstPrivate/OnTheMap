//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, NavigationConfigurable {
    
    @IBOutlet weak var mapView: MKMapView!
    let viewModel = StudentLocationsViewModel.shared
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()

        self.activityIndicator.startAnimating()
        viewModel.getStudentLocationsWith { (success, error) in
            self.activityIndicator.stopAnimating()
            if let err = error{
                self.displayAlert(message: err.description)
            }
            else{
                self.addAnnotations()
            }
        }
        viewModel.getUserInfo()
    }
    
    @IBAction func refreshList(_ sender: Any) {
        self.activityIndicator.startAnimating()

        viewModel.getStudentLocationsWith{ (success, error) in
            self.activityIndicator.stopAnimating()

            if let err = error{
                self.displayAlert(message: err.description)
            }
            else{
                self.addAnnotations()
            }
        }

    }
    @IBAction func createNewAnnotation(_ sender: Any) {
        self.viewModel.currentUserLoccation()
        if viewModel.isUpdating{
            let vc = UIAlertController(title: "Existing Location Found", message: "Would you like to update your exisiting location?", preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (segue) in
                self.navigateToAddPinView()
            }))
            vc.addAction(UIAlertAction(title: "Cancel", style: .default))
            self.present(vc, animated: true)
        }
        else{
            self.navigateToAddPinView()
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        self.activityIndicator.startAnimating()
        viewModel.logout { (success, error) in
            self.activityIndicator.stopAnimating()
            if let err = error{
                self.displayAlert(message: err.description)
            }
            else{
                guard let window = UIApplication.shared.keyWindow else{
                    return
                }
                let controller = self.storyboard?.instantiateInitialViewController()
                window.rootViewController = controller
            }
        }
    }
    func navigateToAddPinView(){
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func addAnnotations(){
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for location in viewModel.result {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            guard let lat = location.latitude, let long = location.longitude, let first = location.firstName, let lastname =  location.lastName, let media = location.mediaURL else{
                return
            }
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
        
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(lastname)"
            annotation.subtitle = media
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
        
    }
}

extension MapViewController: MKMapViewDelegate{
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
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let toOpen = view.annotation?.subtitle!, let url = URL(string: toOpen) else{
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}


