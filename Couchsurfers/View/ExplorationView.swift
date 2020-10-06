//
//  ExplorationView.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 01..
//

import SwiftUI

struct ExplorationView: View {
    @State private var cityNameText: String = ""
    @State private var isShowingSearchingView = false
    
    @ObservedObject var explorationVM = ExplorationViewModel()
    
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
                        
                        RandomLocationView()
                        Divider()
                        
                        Text(NSLocalizedString("goNearText", comment: "Go near"))
                            .font(.custom("Pacifico-Regular", size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 10)
                        
                        Text(NSLocalizedString("discoverNearbyPlacesText", comment: "Discover nearby places"))
                            .font(.system(size: 12))
                        
                        Button(action : {
                            // action
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
    var body: some View {
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
                    Text("4.5")
                    Text("(22)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Budapest, Hungary")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Parking, bikes, wifi, garden")
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
    }
}
