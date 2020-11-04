//
//  RootView.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 01..
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        
        if env.userLoggedIn {
            MainTabView()
        } else {
            RegistrationView()
        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
