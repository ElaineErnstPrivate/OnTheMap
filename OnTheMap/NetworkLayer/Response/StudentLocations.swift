//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

// MARK: - StudentLocations
struct StudentLocations: Codable {
    let results: [Results]
}

// MARK: - Result
struct Results: Codable {
    let createdAt, firstName, lastName: String?
    let latitude, longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectID, uniqueKey, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt, firstName, lastName, latitude, longitude, mapString, mediaURL
        case objectID = "objectId"
        case uniqueKey, updatedAt
    }
}

// MARK: - NewPinResponse
struct NewPinResponse: Codable {
    let createdAt, objectID: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectID = "objectId"
    }
}

struct UpdatedPinResponse: Codable{
    var updatedAt : String
}
