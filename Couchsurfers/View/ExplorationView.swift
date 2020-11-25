//
//  ExplorationView.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 01..
//

import SwiftUI
import CoreLocation

struct ExplorationView: View {
    @ObservedObject private var explorationVM = ExplorationViewModel()
    @ObservedObject private var locationManager = LocationManager()
    
    @State private var cityNameText: String = ""
    @State private var isShowingSearchingView = false
    @State private var couch: Couch?
    @State private var reversedPlaceId: String?
    
    var body: some View {
        ZStack {
            Group {
                if cityNameText != "" {
                    List {
                        ForEach(explorationVM.places, id: \.id) { result in
                            Text(result.description)
                                .onTapGesture {
                                    cityNameText = ""
                                }
                        }
                    }
                } else {
                    ScrollView {
                        Text(NSLocalizedString("rndmPlaceToVisitText", comment: "Random place"))
                            .font(.custom("Pacifico-Regular", size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 10)
                            .padding(.top, 5)
                        
                        RandomLocationView(couch: $couch, cityName: $reversedPlaceId)
                        
                        Divider()
                        
                        Text(NSLocalizedString("goNearText", comment: "Go near"))
                            .font(.custom("Pacifico-Regular", size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 10)
                        
                        Text(NSLocalizedString("discoverNearbyPlacesText", comment: "Discover nearby places"))
                            .font(.system(size: 12))
                        
                        Button(action : {
                            explorationVM.saveExampleData()
                            locationManager.requestLocation()
                            locationManager.isShowingSpinner = true
                        }) {
                            Text(NSLocalizedString("exploreNearbyButton", comment: "Explore nearby"))
                                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                .frame(width: 350, height: 50)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                                .background(Color.white)
                        )
                        .cornerRadius(10)
                        .padding(.vertical, 30)
                    }
                }
            }
            .onAppear {
                explorationVM.generateSessionToken()
            }
            .padding(.top, 50)
            
            VStack {
                AutocompleteTextField(cityNameText: $cityNameText, explorationVM: explorationVM)
                Divider()
                Spacer()
            }
            
            if(locationManager.isShowingSpinner) {
                CustomProgressView()
            }
        }.onAppear() {
            explorationVM.loadNewestCouch { (couch, error, cityName) in
                if error != nil {
                    return
                }
                
                if let couch = couch, let cityName = cityName {
                    self.couch = couch
                    self.reversedPlaceId = cityName
                }
            }
        }
    }
}

struct CustomProgressView: View {
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            
            ProgressView()
                .scaleEffect(2.5, anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .frame(width: 150, height: 150, alignment: .center)
                .cornerRadius(10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .background(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                        .opacity(0.7)
                )
                .cornerRadius(20)
        }
    }
}

struct AutocompleteTextField: View {
    @Binding var cityNameText: String
    
    let explorationVM: ExplorationViewModel
    
    var body: some View {
        TextField(NSLocalizedString("destinationPlaceholder", comment: "Where are you going?"), text: $cityNameText)
            .padding(.horizontal, 40)
            .frame(width: 350, height: 30, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 1)
                    .background(Color(#colorLiteral(red: 0.9685322642, green: 0.9686941504, blue: 0.9685109258, alpha: 1)))
            )
            .cornerRadius(10)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                    Spacer()
                    if cityNameText != "" {
                        Image(systemName: "xmark.circle.fill")
                            .onTapGesture {
                                self.cityNameText = ""
                            }
                    }
                }
                .padding(), alignment: .center)
            .onChange(of: cityNameText) {
                if $0 == "" {
                    explorationVM.generateSessionToken()
                } else {
                    explorationVM.autocomplete(cityname: $0)
                }
            }
            .padding(.top, 10)
    }
}

struct RandomLocationView: View {
    @Binding var couch: Couch?
    @Binding var cityName: String?
    
    var body: some View {
        if let couch = couch {
            VStack(spacing: 5) {
                Image("flat-image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 200, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack {
                    HStack(alignment: .center, spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(#colorLiteral(red: 0.3333333333, green: 0.6509803922, blue: 0.1882352941, alpha: 1)))
                        Text(String(couch.rating))
                        Text("(\(couch.numberOfReviews))")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(cityName ?? NSLocalizedString("unknown", comment: "Unkown"))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(couch.amenities)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 5)
                .frame(width: 350, height: 80)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 1)
                    .background(Color(#colorLiteral(red: 0.9685322642, green: 0.9686941504, blue: 0.9685109258, alpha: 1)))
            )
        } else {
            Text(NSLocalizedString("noSavedCouches", comment: "No saved couches"))
        }
    }
}
