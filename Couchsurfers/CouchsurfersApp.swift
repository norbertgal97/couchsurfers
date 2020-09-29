//
//  CouchsurfersApp.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 09. 27..
//

import SwiftUI

@main
struct CouchsurfersApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            if appDelegate.userLoggedIn {
                // ExplorationView will be here. This is here just for testing purposes.
                RegistrationView()
            } else {
                RegistrationView()
            }
            
        }
    }
}
