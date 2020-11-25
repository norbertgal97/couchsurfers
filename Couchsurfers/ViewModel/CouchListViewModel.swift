//
//  CouchListViewModel.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 11. 24..
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Alamofire

class CouchListViewModel: ObservableObject {
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
