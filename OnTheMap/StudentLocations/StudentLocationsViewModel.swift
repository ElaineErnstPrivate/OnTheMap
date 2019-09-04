//
//  StudentLocationsViewModel.swift
//  OnTheMap
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation
import MapKit
class StudentLocationsViewModel{
    private var manager = URLSessionProvider()
    static let shared = StudentLocationsViewModel()
    var address : String = ""
    var url : String = ""
    var result : [Results] = []
    var annotation = MKPointAnnotation()
    var objectID: String = ""
    var isUpdating :Bool = false
    var userName : String?
    var lastname : String?
    
    func getStudentLocationsWith( handler: @escaping(_ success: Bool, _ error: NetworkError?) -> Void){
        clearResults()
        let request = GetStudentLocation(limit: 100, order:"-updatedAt")
        manager.request(type: StudentLocations.self, service: StudentLocationAPI.getLocationsWith(request)) { (response) in
            switch response{
            case .failure(let error):
                DispatchQueue.main.async {
                    handler(false, error)
                }
            case .success(let locations):
                self.result = locations.results
                DispatchQueue.main.async {
                    handler(true, nil)
                }
            }
        }
    }
    
    
    func getUserInfo(){
    
        manager.request(type: User.self, service: LoginAPI.getUserData(userId: NetworkManager.shared.uniqueKey)) { (response) in
            switch response{
            case .failure(let error):
                print("Error:", error)
            case .success(let result):
                self.userName = result.user.firstName
                self.lastname = result.user.lastName
                
            }
        }
    }
    func currentUserLoccation(){
        for student in result {
            if student.uniqueKey == NetworkManager.shared.uniqueKey {
                isUpdating = true
                objectID = student.objectID!
                break
            }
        }
    }
    
    func addNewLocation(handler: @escaping(_ success: Bool, _ error: NetworkError?) -> Void){
        guard let firstname = userName, let lastname = lastname else{
            return
        }
        let request = Location(firstName: firstname, lastName: lastname, uniqueKey: NetworkManager.shared.uniqueKey, latitude: self.annotation.coordinate.latitude, longitude: self.annotation.coordinate.longitude, mapString: self.annotation.title, mediaURL: self.url)
        manager.request(type: NewPinResponse.self, service: StudentLocationAPI.addLocation(request)) { (response) in
            switch response{
            case .failure(let error):
                DispatchQueue.main.async {
                    handler(false, error)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.objectID = response.objectID
                    handler(true, nil)
                }
            }
        }
    }
    
    func updateUserLocation(handler: @escaping(_ success: Bool, _ error: NetworkError?) -> Void){
        guard let firstname = userName, let lastname = lastname else{
            return
        }
        let request = UpdateStudentLocation(firstName: firstname, lastName: lastname, latitude: self.annotation.coordinate.latitude, longitude: self.annotation.coordinate.longitude, mapString: self.annotation.title, mediaURL: self.url, uniqueKey: NetworkManager.shared.uniqueKey)
        manager.request(type: UpdatedPinResponse.self, service: StudentLocationAPI.updateUserLocation(request, objectID: objectID)){ (response) in
            switch response{
            case .failure(let error):
                DispatchQueue.main.async {
                    handler(false, error)
                }
            case .success(_):
                DispatchQueue.main.async {
                    handler(true, nil)
                }
            }
        }
    }
    
    func logout(handler: @escaping(_ success: Bool, _ error: NetworkError?) -> Void){
        clearResults()
        manager.request(type: Logout.self, service: LoginAPI.logout) { response in
            switch response{
            case .failure(let error):
                DispatchQueue.main.async {
                    handler(false, error)
                }
            case .success(_):
                DispatchQueue.main.async {
                    handler(true, nil)
                }
            }
        }
    }
    
    func clearResults(){
        address = ""
        url = ""
        objectID = ""
        isUpdating = false
        result = []
    }
}
