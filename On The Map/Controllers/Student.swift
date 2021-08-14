//
//  StudentRequests.swift
//  On The Map
//
//  Created by Ruslan Ismayilov on 8/10/21.
//

import Foundation
class Student {
    
    
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
    class func getStudentsLocationRequest(completion : @escaping( StudentLocationResults?, Error? ) -> Void){
        let task = URLSession.shared.dataTask(with: Endpoints.studentLocation.url) { data, response, error in
            guard let data = data else {
                completion(nil,error)
                return
            }
            let decoder = JSONDecoder()
            do {
            let responseObject = try decoder.decode(StudentLocation.self, from: data)
                
            } catch {
                
                completion(nil, error)
            }
        }
        task.resume()
    }
    
}
