//
//  NetorkManager.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

class NetworkManager{
    
     static let shared = NetworkManager()
     var baseUrl : String = "https://onthemap-api.udacity.com/v1"
     var sessionId: String = ""
    var uniqueKey : String = ""
     func configureNetworkLayer(baseUrl: String){
        self.baseUrl = baseUrl
    }
}
