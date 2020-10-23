//
//  CouchsurfersApp.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 09. 27..
//

import SwiftUI
import Firebase
import FBSDKCoreKit

@main
struct CouchsurfersApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(GlobalEnvironment(Auth.auth().currentUser != nil))
                .onOpenURL(perform: { url in
                    ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: UIApplication.OpenURLOptionsKey.annotation)
                    
                })
        }
    }
}

struct CouchsurfersApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

class GlobalEnvironment: ObservableObject {
    @Published var userLoggedIn = false
    
    init(_ userLoggedIn: Bool) {
        self.userLoggedIn = userLoggedIn
    }
}
