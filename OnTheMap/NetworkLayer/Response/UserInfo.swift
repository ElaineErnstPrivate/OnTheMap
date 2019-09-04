//
//  UserInfo.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/04.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation
// MARK: - User
struct User: Codable {
    let user: UserDetails
}

// MARK: - UserClass
struct UserDetails: Codable {
    let lastName: String
    let firstName: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }
}

