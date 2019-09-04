//
//  StudentLocationRequst.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

struct Location: Codable {
    var firstName, lastName, uniqueKey: String?
    var latitude, longitude: Double?
    var mapString, mediaURL: String?
}

struct GetStudentLocation: Codable{
    var limit: Int?
    var skip : Int?
    var order: String?
    var results: String?
    var uniqueKey: String?
    init(limit: Int? = nil, skip: Int? = nil, order: String? = nil, results: String? = nil, uniqueKey: String? = nil){  
        if limit != nil{
            self.limit = limit
        }
        if skip != nil{
            self.skip = skip
        }
        if order != nil{
            self.order = order
        }
        if results != nil{
            self.results = results
        }
        if uniqueKey != nil{
            self.uniqueKey = uniqueKey
        }
    }
}

struct UpdateStudentLocation: Codable {
        let firstName, lastName: String?
        let latitude, longitude: Double?
        let mapString ,mediaURL, uniqueKey: String?
}
