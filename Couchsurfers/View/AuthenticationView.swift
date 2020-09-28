//
//  AuthenticationView.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 09. 27..
//

import SwiftUI

struct AuthenticationView: View {
    
    @ObservedObject var authenticationVM = AuthenticationViewModel()
    
    var body: some View {
        VStack {
            Button(action : {
                authenticationVM.createNewFirebaseUser(email: "asd@gmail.com", password: "probaJelszo123")
            }) {
                Text("Button")
            }
        }.onAppear {
            authenticationVM.attachStateDidChangeListenerToFirebaseAuth()
        }.onDisappear {
            authenticationVM.detachStateDidChangeListenerFormFirebaseAuth()
        }.alert(isPresented: $authenticationVM.showingAlert, content: {
            Alert(title: Text("Information"), message: Text(authenticationVM.alertDescription ?? "Sorry! Alert message is missing."), dismissButton: .default(Text("Continue")) {
                    print("Dismiss button pressed")
                })
        })
    }
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
