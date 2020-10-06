//
//  Predictions.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 02..
//

import Foundation

struct Predictions: Decodable {
    let all: [Place]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case all = "predictions"
        case status
    }
}

struct Place: Decodable {
    let id: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case description
    }
}
