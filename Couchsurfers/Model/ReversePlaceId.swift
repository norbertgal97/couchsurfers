//
//  ReversePlaceId.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 27..
//

import Foundation

struct ReversePlaceId: Decodable {
    let result: PlaceIdResult
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case result
        case status
    }
}

struct PlaceIdResult: Decodable {
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case address = "formatted_address"
    }
}
