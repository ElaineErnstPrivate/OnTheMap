//
//  LoginViewModel.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

class LoginViewModel{
    private var manager = URLSessionProvider()
    
    func login(_ username: String, password: String, handler: @escaping(_ success: Bool, _ error: NetworkError?) -> Void){
        let request = LoginRequest(username: username, password: password)
        manager.request(type: Login.self, service: LoginAPI.login(credentials: LoginReq(udacity: request))) { response in
            switch response {
            case .success(let loginDetails):
                NetworkManager.shared.sessionId = loginDetails.session.id
                NetworkManager.shared.uniqueKey = loginDetails.account.key

                handler(true, nil)
            case .failure(let error):
                handler(false,error)
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
