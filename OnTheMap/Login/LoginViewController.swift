//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, NavigationConfigurable, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    private var viewModel = LoginViewModel()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        let signUpValue = "Don't have an account? Sign up"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: signUpValue)
        attributedString.setColorForText(textForAttribute: "Don't have an account?", withColor: UIColor.black)
        attributedString.setColorForText(textForAttribute: "Sign up", withColor: UIColor.blue)
        // Do any additional setup after loading the view.
        self.signUpButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let url = URL(string: "https://www.udacity.com/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func submitLogin(_ sender: Any) {
        
        guard username.text != "", password.text != "" else{
            self.displayAlert(message: "Enter all user credentials")
            return
        }
        
        self.activityIndicator.startAnimating()
        viewModel.login(username.text!, password: password.text!) { (success, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if let err = error{
                    self.displayAlert(message:err.description)
                }
                else
                {
                    guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "StudentLocations"), let window = UIApplication.shared.keyWindow else{
                        return
                    }
                    
                    window.rootViewController = controller
                }
            }
           
        }
    }
}

extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
}
