
//
//  File.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

enum LoginAPI{
    case login(credentials: LoginReq)
    case logout
    case getUserData(userId: String)
}

extension LoginAPI: ServiceProtocol{
     var baseURL: URL {
        switch self {
        case .login(_):
            return URL(string: NetworkManager.shared.baseUrl)!
        case .logout:
            return URL(string: NetworkManager.shared.baseUrl)!
        case .getUserData:
            return URL(string: NetworkManager.shared.baseUrl)!

        }
    }
    
     var path: String {
        switch self {
        case .login(_):
            return "/session"
        case .logout:
            return "/session"
        case .getUserData(let userID):
            return "/users/\(userID)"
        }
    }
    
     var method: HTTPMethod {
        switch self {
        case .login(_):
            return .post
        case .logout:
            return .delete
        case .getUserData:
            return .get
        }
    }
    
     var task: HTTPTask{
        switch self{
        case .login(let params):
            do{
                let param = try params.asDictionary()
                return .requestParameters(param)
                
            }
            catch{
                return .requestPlain
            }
        case .logout:
            return .requestPlain
        case .getUserData:
            return .requestPlain
        }
      
    }
    
     var parametersEncoding: ParametersEncoding {
        switch self {
        case .login(_):
            return .json
        case .logout:
            return .json
        case .getUserData:
            return .json
        }
    }
    
     var headers: Headers? {
        switch self{
        case .login(_):
            
            let headers = ["Content-Type": "application/json",
                               "Accept" : "application/json"]
            
            return headers
        case .logout:
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                let headers = ["XSRF-TOKEN": xsrfCookie.value]
                return headers
                
            }
            else{
                let headers = ["Content-Type": "application/json",
                               "Accept" : "application/json"]
                
                return headers
            }
            
        case .getUserData:
            
                let headers = ["Content-Type": "application/json",
                               "Accept" : "application/json"]
                
                return headers
        }
    }
}

