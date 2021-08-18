//
//  LoginResponse.swift
//  On The Map
//
//  Created by Ruslan Ismayilov on 8/17/21.
//

import Foundation
struct LoginResponse : Codable {
    let account : Account
    let session : Session
}


struct Account : Codable {
    let registered : Bool
    let key : String
}

struct Session : Codable {
    let id : String
    let expiration : String
}

