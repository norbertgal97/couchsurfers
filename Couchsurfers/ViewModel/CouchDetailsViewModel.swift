//
//  CouchDetailsViewModel.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 11. 23..
//

import Foundation
import Firebase
import Alamofire

class CouchDetailsViewModel: ObservableObject {
    @Published var sessionToken: String = UUID().uuidString
    @Published var places = [Place]()
    @Published var alertDescription: String = NSLocalizedString("defaultAlertMessage", comment: "Default alert message")
    @Published var showingAlert = false
    
    private var API_KEY = ""
    
    init() {
        if let path = Bundle.main.url(forResource:"Info", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: path)
                let swiftDictionary = try PropertyListSerialization.propertyList(from: data, format: nil) as! [String:Any]
                API_KEY = swiftDictionary["GoogleApiKey"] as! String
            } catch {
                print(error)
            }
        }
    }
    
    func autocomplete(cityname: String) {
        
        let requestUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(cityname)&types=(cities)&key=\(API_KEY)&language=\(NSLocalizedString("placesAPIlanguage", comment: "language"))&types=(cities)&sessiontoken=\(sessionToken)"
        
        AF.request(requestUrl)
            .validate()
            .responseDecodable(of: Predictions.self) { response in
                
                switch response.result {
                case .success:
                    print(self.sessionToken)
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
    
    func saveNewCouch(place_id: String, amenities: String, numberOfGuests: Int, accomodationName: String, description: String, completionHandler: @escaping (Bool) -> Void) {
        if place_id.isEmpty || accomodationName.isEmpty {
            alertDescription = NSLocalizedString("emptyFields", comment: "Empty fields")
            self.showingAlert = true
            completionHandler(false)
            return
        }
        
        let couch = Couch(user_id: Auth.auth().currentUser!.uid, place_id: place_id, rating: 0, numberOfReviews: 0, amenities: amenities, name: accomodationName, description: description ,created: Timestamp(date: Date()), numberOfGuests: numberOfGuests)
        
        do {
            try db?.collection("couches").document(Auth.auth().currentUser!.uid).setData(from: couch, merge: true)
            completionHandler(true)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
            completionHandler(false)
        }
    }
    
    func loadMyCouch(completionHandler: @escaping (Couch?, Error?, String?) -> Void) {
        let couchRef = Firestore.firestore().collection("couches").document(Auth.auth().currentUser!.uid)
        couchRef.getDocument { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let result = Result {
                    try document?.data(as: Couch.self)
                }
                
                switch result {
                case .success(let couch):
                    let requestUrl = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(couch?.place_id ?? "ChIJyc_U0TTDQUcRYBEeDCnEAAQ")&key=\(self.API_KEY)"
                    AF.request(requestUrl)
                        .validate()
                        .responseDecodable(of: ReversePlaceId.self) { response in
                            
                            switch response.result {
                            case .success:
                                completionHandler(couch, nil, response.value?.result.address)
                            case .failure(let error):
                                print(error.localizedDescription)
                                completionHandler(couch, nil, nil)
                            }
                        }
                    
                case .failure(let error):
                    completionHandler(nil, error, nil)
                    print("Error decoding city: \(error)")
                }
            }
        }
    }
}
