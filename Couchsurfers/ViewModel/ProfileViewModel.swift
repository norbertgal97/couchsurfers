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
