//
//  ExplorationViewModel.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 01..
//

import SwiftUI
import Alamofire
import CoreLocation
import Firebase
import FirebaseFirestoreSwift

class ExplorationViewModel: ObservableObject {
    @Published var cityName = ""
    @Published var sessionToken: String = UUID().uuidString
    @Published var places = [Place]()
    @Published var userLoggedIn = false
    
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
    
    func loadNewestCouch(completionHandler: @escaping (Couch?, Error?, String?) -> Void) {
        let couchRef = Firestore.firestore().collection("couches")
        couchRef.order(by: "created", descending: true).limit(to: 1).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let result = Result {
                        try document.data(as: Couch.self)
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
    
    func saveExampleData() {
        //https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJrTLr-GyuEmsRBfy61i59si0&key=YOUR_API_KEY
        let couch = Couch(user_id: Auth.auth().currentUser!.uid, place_id: "aswdfcrg", rating: 4.5, numberOfReviews: 22, amenities: "Wifi, Kitchen", name: "asd", description: "asd", created: Timestamp(date: Date()), numberOfGuests: 5)
        
        do {
            try db?.collection("couches").document().setData(from: couch)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    func generateSessionToken() {
        sessionToken = UUID().uuidString
    }
}

class LocationManager: NSObject, ObservableObject {
    @Published var reverseGeoResult = [Location]()
    @Published var location: CLLocation? = nil
    @Published var showNearbyPlaces = false
    @Published var isShowingSpinner = false
    
    private var API_KEY : String = ""
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.requestWhenInUseAuthorization()
        
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
    
    
    func requestLocation() {
        self.locationManager.requestLocation()
    }
    
}

extension LocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        self.location = location
        print("Found user's location: \(location)")
        
        let requestUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(location.coordinate.latitude),\(location.coordinate.longitude)&key=\(API_KEY)&result_type=locality"
        AF.request(requestUrl)
            .validate()
            .responseDecodable(of: ReverseGeo.self) { response in
                
                switch response.result {
                case .success:
                    print("Success")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                guard let results = response.value else { return }
                self.reverseGeoResult = results.all
                self.isShowingSpinner = false
                self.showNearbyPlaces = true
            }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.showNearbyPlaces = false
        self.isShowingSpinner = false
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
