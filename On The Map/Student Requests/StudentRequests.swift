//
//  StudentRequests.swift
//  On The Map
//
//  Created by Ruslan Ismayilov on 8/10/21.
//

import Foundation
class StudentRequest {
    
    enum Endpoints{
        static let base = "https://onthemap-api.udacity.com/v1/StudentLocation"
        case website
        
        
        
        var stringValue : String{
            switch self {
            case .website:
                return Endpoints.base
            }
        }
        
        var url : URL {
            return URL(string: stringValue)!
        }
        
    }
    
    
}
