//
//  ProfileView.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 11..
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileVM = ProfileViewModel()
    
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        VStack {
            Button(action: {
                profileVM.logOut() { result in
                    if !result {
                        self.env.userLoggedIn = result
                    }
                }
            }) {
                Text("Log out")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
