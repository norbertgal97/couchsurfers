//
//  User.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 30..
//

import Foundation
import Firebase

struct User: Decodable {
    let firstName: String
    let lastName: String
    let phone: String
    let gender: Int
    let created: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case phone
        case gender
        case created
    }
}
