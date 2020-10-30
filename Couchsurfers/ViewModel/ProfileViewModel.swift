//
//  ProfileViewModel.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 11..
//

import Foundation
import Firebase
import FBSDKLoginKit
class ProfileViewModel: ObservableObject {
    
    func loadUsername(completionHandler: @escaping (String) -> Void) {
        let docRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completionHandler(document.get("firstName") as! String)
            } else {
                completionHandler("Unknown")
            }
        }
    }
    
    func logOut(completionHandler: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            LoginManager().logOut()
            completionHandler(false)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            completionHandler(true)
        }
    }
    
}
