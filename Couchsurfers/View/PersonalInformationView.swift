//
//  PersonalInformationView.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 30..
//

import SwiftUI

struct PersonalInformationView: View {
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var personalInformationVM = PersonalInformationViewModel()
    
    @State private var selectedGender = 0
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var number: String = ""
    @State private var isLoaded = false
    
    var body: some View {
        VStack {
            
            Text(NSLocalizedString("pInformation", comment: "Personal information"))
                .font(.custom("Pacifico-Regular", size: 30))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 25)
                .padding(.horizontal, 10)
            
            Form {
                Section(header: Text(NSLocalizedString("name", comment: "NAME"))) {
                    TextField(NSLocalizedString("firstName", comment: "First name"), text: $firstName)
                        .padding(.horizontal, 10)
                    
                    TextField(NSLocalizedString("lastName", comment: "Last name"), text: $lastName)
                        .padding(.horizontal, 10)
                }
                
                Section(header: Text(NSLocalizedString("gender", comment: "GENDER"))) {
                    Picker(selection: $selectedGender, label: Text(NSLocalizedString("selectGender", comment: "Select Gender"))) {
                        ForEach(0 ..< GenderType.allCases.count) {
                            Text(NSLocalizedString(GenderType.allCases[$0].localizedString(), comment: ""))
                        }
                    }
                    .padding(.horizontal, 10)
                }
                
                Section(header: Text(NSLocalizedString("phoneNumber", comment: "PHONE NUMBER"))) {
                    TextField(NSLocalizedString("number", comment: "Number"), text: $number)
                        .keyboardType(.phonePad)
                        .padding(.horizontal, 10)
                }
            }
            
        }
        .navigationBarItems(trailing: Button(NSLocalizedString("save", comment: "Save")) {
            personalInformationVM.saveUserInformation(firstName: firstName, lastName: lastName, gender: selectedGender, phone: number)
            self.presentation.wrappedValue.dismiss()
        })
        .onAppear {
            if isLoaded {
                return
            }
            
            personalInformationVM.loadUserInformation { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let user = user {
                    self.firstName = user.firstName
                    self.lastName = user.lastName
                    self.number = user.phone
                    self.selectedGender = user.gender
                    self.isLoaded = true
                }
                
            }
        }
        
    }
}
