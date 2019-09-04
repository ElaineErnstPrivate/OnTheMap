//
//  NavigationConfigurable.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//
//
import Foundation
import UIKit
protocol NavigationConfigurable: class {
    func configureNavigation()
}

extension NavigationConfigurable where Self: UIViewController {

    func configureNavigation(){
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
}
