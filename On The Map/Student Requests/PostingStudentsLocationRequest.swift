//
//  PostingStudentsLocationRequest.swift
//  On The Map
//
//  Created by Ruslan Ismayilov on 8/22/21.
//

import Foundation

struct PostingStudentsLocationRequest : Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    }
