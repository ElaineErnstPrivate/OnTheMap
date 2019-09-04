//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

struct LoginReq : Codable {
    var udacity: LoginRequest
}

struct  LoginRequest: Codable {
    var username : String
    var password: String
    
    init(username: String, password: String) {
         self.username = username
        self.password = password
    }
}
