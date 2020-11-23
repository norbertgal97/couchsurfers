//
//  LoginViewModel.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 01..
//

import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    @Published var emailAddress = ""
    @Published var password = ""
    @Published var showingAlert = false
    @Published var alertDescription: String = NSLocalizedString("defaultAlertMessage", comment: "Default alert message")
    
    func signInUser(email: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        
        if email.isEmpty || password.isEmpty {
            alertDescription = NSLocalizedString("emptyFields", comment: "Empty fields")
            self.showingAlert = true
            completionHandler(false)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if let unwrappedError = error {
                let errorCode = AuthErrorCode(rawValue: unwrappedError._code)
                
                switch errorCode {
                case .invalidEmail:
                    self.alertDescription = NSLocalizedString("invalidEmailAddress", comment: "Invalid email")
                case .userDisabled:
                    self.alertDescription = NSLocalizedString("userDisabled", comment: "User disabled")
                case .operationNotAllowed:
                    self.alertDescription = NSLocalizedString("operationNotAllowed", comment: "Operation not allowed")
                case .wrongPassword:
                    self.alertDescription = NSLocalizedString("wrongPassword", comment: "Wrong password")
                default:
                    self.alertDescription = NSLocalizedString("unknownError", comment: "Unknown error")
                }
                
                self.showingAlert = true
                completionHandler(false)
            }
            
            if authResult != nil {
                print("User is signed in")
                completionHandler(true)
            }
        }
        
    }
    
}
