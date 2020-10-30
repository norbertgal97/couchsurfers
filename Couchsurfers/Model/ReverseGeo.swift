//
//  ReverseGeo.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 24..
//

import Foundation

struct ReverseGeo: Decodable {
    let all: [Location]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case all = "results"
        case status
    }
}

struct Location: Decodable {
    let address: String
    let place_id: String
    
    enum CodingKeys: String, CodingKey {
        case address = "formatted_address"
        case place_id
    }
}
