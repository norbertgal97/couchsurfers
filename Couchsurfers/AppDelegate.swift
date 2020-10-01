//
//  AppDelegate.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 09. 27..
//

import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    var userLoggedIn = false
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        if Auth.auth().currentUser != nil {
            userLoggedIn = true
        } else {
            userLoggedIn = false
        }
        
        return true
    }
}
