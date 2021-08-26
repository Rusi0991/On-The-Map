//
//  PublicUserDataResponse.swift
//  On The Map
//
//  Created by Ruslan Ismayilov on 8/14/21.
//

import Foundation
struct PublicUserData: Codable {
    var firstName: String
    var lastName: String
 
    enum CodingKeys: String, CodingKey {

        case firstName = "first_name"
        case lastName = "last_name"
    }
}
