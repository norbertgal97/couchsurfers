//
//  CouchDetailsView.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 11. 23..
//

import SwiftUI

struct CouchDetailsView: View {
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var couchDetailsVM = CouchDetailsViewModel()
    
    @State private var numberOfGuests = 0
    @State private var name: String = ""
    @State private var cityNameText: String = ""
    @State private var selectedCity: String = ""
    @State private var description: String = ""
    @State private var amenities: String = ""
    @State private var isLoaded = false
    @State private var cityId = ""
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text(NSLocalizedString("city", comment: "CITY"))) {
                    if selectedCity != "" {
                        TextField(NSLocalizedString("locationPlaceholder", comment: "Location"), text: $selectedCity)
                            .disabled(true)
                            .overlay(
                                HStack {
                                    Spacer()
                                    if self.selectedCity != "" {
                                        Image(systemName: "xmark.circle.fill")
                                            .onTapGesture {
                                                self.selectedCity = ""
                                            }
                                    }
                                }
                                .padding(), alignment: .center)
                    } else {
                        AutocompleteField(cityNameText: $cityNameText, couchDetailsVM: couchDetailsVM)
                            .overlay(
                                HStack {
                                    Spacer()
                                    if cityNameText != "" {
                                        Image(systemName: "xmark.circle.fill")
                                            .onTapGesture {
                                                self.cityNameText = ""
                                            }
                                    }
                                }
                                .padding(), alignment: .center)
                    }
                    
                    if cityNameText != "" {
                        List {
                            ForEach(couchDetailsVM.places, id: \.id) { result in
                                Text(result.description)
                                    .onTapGesture {
                                        cityNameText = ""
                                        selectedCity = result.description
                                        cityId = result.id
                                    }
                            }
                        }
                    }
                }
                
                Section(header: Text(NSLocalizedString("name", comment: "NAME"))) {
                    TextField(NSLocalizedString("couchName", comment: "Couch name"), text: $name)
                        .padding(.horizontal, 10)
                }
                
                Section(header: Text(NSLocalizedString("guests", comment: "GUESTS"))) {
                    Picker(selection: $numberOfGuests, label: Text(NSLocalizedString("numOfGuests", comment: "Number of guests"))) {
                        ForEach(0 ..< 15) {
                            Text("\($0) guests")
                        }
                    }
                    .padding(.horizontal, 10)
                }
                
                Section(header: Text(NSLocalizedString("description", comment: "DESCRIPTION"))) {
                    TextEditor(text: $description)
                        .frame(width: 350, height: 200, alignment: .center)
                }
                
                Section(header: Text(NSLocalizedString("amenities", comment: "AMENITIES"))) {
                    TextField(NSLocalizedString("amenitiesExample", comment: "Amenities example") , text: $amenities)
                }
                
            }
        }
        .navigationBarTitle(Text(NSLocalizedString("couchDetails", comment: "Couch details")))
        .navigationBarItems(trailing: Button(NSLocalizedString("save", comment: "Save")) {
            couchDetailsVM.saveNewCouch(place_id: cityId, amenities: amenities, numberOfGuests: numberOfGuests, accomodationName: name, description: description) { result in
                if result {
                    self.presentation.wrappedValue.dismiss()
                }
            }
        })
        .onAppear {
            if isLoaded {
                return
            }
            
            couchDetailsVM.loadMyCouch { (couch, error, cityName) in
                if error != nil {
                    return
                }
                
                if let couch = couch, let cityName = cityName {
                    self.cityId = couch.place_id
                    self.selectedCity = cityName
                    self.numberOfGuests = couch.numberOfGuests
                    self.name = couch.name
                    self.amenities = couch.amenities
                    self.description = couch.description
                    self.isLoaded = true
                }
            }
        }
        .alert(isPresented: $couchDetailsVM.showingAlert, content: {
            Alert(title: Text(NSLocalizedString("alertTitle", comment: "Title")), message: Text(couchDetailsVM.alertDescription), dismissButton: .default(Text(NSLocalizedString("dismissButtonText", comment: "Continue"))) {
                print("Dismiss button pressed")
            })
        })
    }
}

struct AutocompleteField: View {
    @Binding var cityNameText: String
    
    let couchDetailsVM : CouchDetailsViewModel
    
    var body: some View {
        TextField(NSLocalizedString("locationPlaceholder", comment: "Location"), text: $cityNameText)
            .onChange(of: cityNameText) {
                if $0 == "" {
                    couchDetailsVM.generateSessionToken()
                } else {
                    couchDetailsVM.autocomplete(cityname: $0)
                }
            }
    }
}
