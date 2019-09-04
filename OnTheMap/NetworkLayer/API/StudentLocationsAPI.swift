//
//  StudentLocationsAPI.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

enum StudentLocationAPI{
    case getLocationsWith(_ locationRequest: GetStudentLocation)
    case addLocation(_ location: Location)
    case updateUserLocation(_ location: UpdateStudentLocation, objectID: String)
}

extension StudentLocationAPI: ServiceProtocol{
    var baseURL: URL {
        switch self {
        case .getLocationsWith(_):
            return URL(string: NetworkManager.shared.baseUrl)!
        case .addLocation(_):
            return URL(string: NetworkManager.shared.baseUrl)!
        case .updateUserLocation(_):
            return URL(string: NetworkManager.shared.baseUrl)!

        }
    }
    
    var path: String {
        switch self {
        case .getLocationsWith(_):
            return "/StudentLocation"
        case .addLocation(_):
            return "/StudentLocation"
        case .updateUserLocation(_, let objectId):
            return "/StudentLocation/\(objectId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getLocationsWith(_):
            return .get
        case .addLocation(_):
            return .post
        case .updateUserLocation(_):
            return .put
        }
    }
    
    var task: HTTPTask{
        switch self{
        case .getLocationsWith(let params):
            do{
                let param = try params.asDictionary()
                return .requestParameters(param)
            }
            catch{
                return .requestPlain
            }
        case .addLocation(let location):
            do{
                let param = try location.asDictionary()
                return .requestParameters(param)
                
            }
            catch{
                return .requestPlain
            }
        case .updateUserLocation(let location, _):
            do{
                let param = try location.asDictionary()
                return .requestParameters(param)
                
            }
            catch{
                return .requestPlain
            }
        }
    }
    
    var parametersEncoding: ParametersEncoding {
        switch self {
        case .getLocationsWith(_):
            return .url
        case .addLocation(_):
            return .json
        case .updateUserLocation(_):
            return .json
        }
    }
    
    var headers: Headers? {
        switch self{
        case .getLocationsWith(_):
            
            let headers = ["Content-Type": "application/json",
                           "Accept" : "application/json"]
            
            return headers
        case .addLocation(_):
            let headers = ["Content-Type": "application/json",
                           "Accept" : "application/json"]
            
            return headers
        case .updateUserLocation(_):
            let headers = ["Content-Type": "application/json",
                           "Accept" : "application/json"]
            
            return headers
        }
    }
}
