//
//  Couch.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 26..
//

import Foundation
import Firebase

public struct Couch: Codable {
    let user_id: String
    let place_id: String
    let rating: Double
    let numberOfReviews: Int
    let amenities: [String]
    let created: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case user_id
        case place_id
        case rating
        case numberOfReviews
        case amenities
        case created
    }
}
