//
//  StudentRequests.swift
//  On The Map
//
//  Created by Ruslan Ismayilov on 8/10/21.
//

import Foundation



class Student{
struct User {
    static var firstName = ""
    static var lastName = ""
    static var createdAt = ""
    static var objectId = ""
    static var location = ""
    static var link = ""
    static var updatedAt = ""
}


struct Auth {
    
    static var accountKey = ""
    static var sessionId = ""
    
}
    
    enum Endpoints{
        static let base = "https://onthemap-api.udacity.com/v1"
        case studentLocation
        case publicUserData
        case login
        case postStudentLocation
        case updateLocation
        
        var stringValue : String {
            switch self {
            case .studentLocation:
                return Endpoints.base + "/StudentLocation?order=-updatedAt"
            case .publicUserData:
                return Endpoints.base  + "/users/\(Auth.accountKey)"
            case.login:
                return Endpoints.base + "/session"
            case .postStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case .updateLocation:
                return Endpoints.base + "/StudentLocation/8ZExGR5uX8"
            }
        }
        
        var url : URL {
            return URL(string: stringValue)!
        }
    }
    
     class func taskForGetRequest<ResponseType : Decodable>(url : URL, response : ResponseType.Type, completion : @escaping(ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                    
                }
                return
            }
            
        
        let decoder = JSONDecoder()
        do {
            let responseObject = try decoder.decode(ResponseType.self, from: data)
            DispatchQueue.main.async {
                completion(responseObject,nil)
            }
        } catch {
            
            do {
                let range = (5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        }
        task.resume()
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable > (url:URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void ){
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
            }
            
        }
        task.resume()
    }
    
    class func getStudentsLocations(completion : @escaping( [StudentLocation], Error? ) -> Void){
        taskForGetRequest(url: Endpoints.studentLocation.url, response: StudentLocationResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
                
            } else {
                completion([], error)
            }
        }
    }
    
    class func getPublicUserData(completion : @escaping(String?, String?, Error?) -> Void){
        taskForGetRequest(url: Endpoints.publicUserData.url, response: PublicUserData.self) { response, error in
            if let response = response{
                completion(response.firstName, response.lastName, nil)
                print("getting user data completed")
                User.firstName = response.firstName
                User.lastName = response.lastName
            } else {
                completion(nil, nil, error)
            }
        }
        
    }
    class func login (username : String, password : String, completion : @escaping(Bool, Error?) -> Void ){
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = ("{\"udacity\": {\"username\": \"" + username + "\", \"password\": \"" + password + "\"}}").data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            do{
            let range =  (5..<data.count)
              let newData = data.subdata(in: range) /* subset response data! */
              print(String(data: newData, encoding: .utf8)!)
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(LoginResponse.self, from: newData)
                DispatchQueue.main.async {
                    Auth.accountKey = responseObject.account.key
                    Auth.sessionId = responseObject.session.id
                    completion(responseObject.account.registered, nil)
                }
                
                
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
            
    }
        task.resume()
    
}
    class func postStudentLocation(firstName : String, lastName : String, mapString : String, mediaURL : String, longitude : Double, latitude : Double, completion : @escaping(Bool, Error?) -> Void){
        
        let body = PostingStudentsLocationRequest(uniqueKey: Auth.accountKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: PostingStudentLocationResponse.self, body: body) { response, error in
            if let response = response {
                User.createdAt = response.createdAt
                User.objectId = response.objectId
                completion(true, nil)
            } else {
                
            completion(false, error)
            }
        }
        
        
    }
    
    class func updateStudentsLocations(firstName : String, lastName : String, mapString : String, mediaURL : String, longitude : Double, latitude : Double, completion : @escaping(Bool, Error?) -> Void) {
        
        
        var request = URLRequest(url: Endpoints.updateLocation.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = PostingStudentsLocationRequest(uniqueKey: Auth.accountKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
    
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(PuttingStudentsLocationResponse.self, from: data)
                User.updatedAt = responseObject.updatedAt
            } catch  {
                do {
                    let range = (5..<data.count)
                    let newData = data.subdata(in: range) /* subset response data! */
                    print(String(data: newData, encoding: .utf8)!)
                    let responseObject = try JSONDecoder().decode(PuttingStudentsLocationResponse.self, from: newData)
                    DispatchQueue.main.async {
                        User.updatedAt = responseObject.updatedAt
                        print("location updated")
                        completion(true, nil)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        task.resume()
        
        
    }
}

