//
//  StudentRequests.swift
//  On The Map
//
//  Created by Ruslan Ismayilov on 8/10/21.
//

import Foundation
class Student {
    
    let accountId = ""
    let sessionId = ""
    
    enum Endpoints{
        static let base = "https://onthemap-api.udacity.com/v1"
        case studentLocation
        case publicUserData
        
        var stringValue : String {
            switch self {
            case .studentLocation:
                return Endpoints.base + "/StudentLocation"
            case .publicUserData:
                return Endpoints.base  + "/users/<user_id>"
                
            }
        }
        
        var url : URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGetRequest<ResponseType : Decodable>(url : URL, response : ResponseType.Type, completion : @escaping(ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                    
                }
                return
            }
            if error != nil {
                //handle error
                return
            }
        
        let decoder = JSONDecoder()
        do {
            let responseObject = try decoder.decode(ResponseType.self, from: data)
            DispatchQueue.main.async {
                completion(responseObject,nil)
            }
        } catch {
            DispatchQueue.main.async {
                completion(nil, error )
            }
        }
        }
        task.resume()
        return task
    }
    
    class func getStudentsLocationRequest(completion : @escaping( [StudentLocation], Error? ) -> Void){
        taskForGetRequest(url: Endpoints.studentLocation.url, response: StudentLocationResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    
    
}
