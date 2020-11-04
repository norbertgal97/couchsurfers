//
//  AppDelegate.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 09. 27..
//

import UIKit
import Firebase
import FBSDKCoreKit

var db: Firestore?

class AppDelegate: NSObject, UIApplicationDelegate {
    var userLoggedIn = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        db = Firestore.firestore()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.userLoggedIn = true
            } else {
                self.userLoggedIn = false
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}
