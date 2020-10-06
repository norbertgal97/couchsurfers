//
//  ExplorationViewModel.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 01..
//

import SwiftUI
import Alamofire

class ExplorationViewModel: ObservableObject {
    @Published var cityName = ""
    @Published var sessionToken: String = UUID().uuidString
    @Published var places = [Place]()
    
    let API_KEY = "SECRET"
    
    func autocomplete(cityname: String) {
        let requestUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(cityname)&types=(cities)&key=\(API_KEY)&language=\(NSLocalizedString("placesAPIlanguage", comment: "language"))&sessiontoken=\(sessionToken)"
        
        AF.request(requestUrl)
            .validate()
            .responseDecodable(of: Predictions.self) { response in
                
                switch response.result {
                case .success:
                    print("Validation successfull")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                guard let predictions = response.value else { return }
                self.places = predictions.all
            }
    }
    
    func generateSessionToken() {
        sessionToken = UUID().uuidString
    }
}
