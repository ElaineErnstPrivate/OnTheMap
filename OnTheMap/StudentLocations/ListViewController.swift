//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit
import SafariServices
class ListViewController: UIViewController, NavigationConfigurable {
    let viewModel = StudentLocationsViewModel.shared
    
    @IBOutlet weak var activityIndicatot: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    // Open media url in browser
    @IBAction func refreshList(_ sender: Any) {
        self.activityIndicatot.startAnimating()
        viewModel.getStudentLocationsWith { (success, error) in
            self.activityIndicatot.stopAnimating()
            if let err = error{
                self.displayAlert(message: err.description)
            }
            else{
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addNewAnnotation(_ sender: Any) {
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
        self.activityIndicatot.startAnimating()
        viewModel.logout { (success, error) in
            self.activityIndicatot.stopAnimating()
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
    
    func openBrowser(_ urlString: String){
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "StudentLocationTableViewCell", for: indexPath) as? StudentLocationTableViewCell
        let student = viewModel.result[indexPath.row]
        guard let firstname = student.firstName, let lastname = student.lastName, let mediaUrl = student.mediaURL else{
            return UITableViewCell()
        }
        cell?.configure(firstName: firstname, lastname: lastname, media: mediaUrl)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = viewModel.result[indexPath.row]
        guard let urlString = student.mediaURL else{
            return
        }
        self.openBrowser(urlString)
    }
    
}
