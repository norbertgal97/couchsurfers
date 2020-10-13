//
//  RegistrationViewModel.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 09. 27..
//

import Foundation
import Firebase
import FBSDKLoginKit

class RegistrationViewModel: ObservableObject {
    @Published var emailAddress = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var showingAlert = false
    @Published var alertDescription: String = NSLocalizedString("defaultAlertMessage", comment: "Default alert message")
    
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func attachStateDidChangeListenerToFirebaseAuth() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                // User is signed in
            } else {
                // No user is signed in
            }
        }
    }
    
    func detachStateDidChangeListenerFormFirebaseAuth() {
        if let unwrappedHandle = handle {
            Auth.auth().removeStateDidChangeListener(unwrappedHandle)
        }
        
    }
    
    func createNewFirebaseUser(email: String, password: String) {
        if email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty {
            self.alertDescription = NSLocalizedString("emptyFields", comment: "Empty fields")
            self.showingAlert.toggle()
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let unwrappedError = error {
                let errorCode = AuthErrorCode(rawValue: unwrappedError._code)
                
                switch errorCode {
                case .invalidEmail:
                    self.alertDescription = NSLocalizedString("invalidEmailAddress", comment: "Invalid email")
                case .emailAlreadyInUse:
                    self.alertDescription = NSLocalizedString("emailAlreadyInUse", comment: "Email already in use")
                case .operationNotAllowed:
                    self.alertDescription = NSLocalizedString("operationNotAllowed", comment: "Operation not allowed")
                case .weakPassword:
                    self.alertDescription = NSLocalizedString("weakPassword", comment: "Weak password")
                default:
                    self.alertDescription = NSLocalizedString("unknownError", comment: "Unknown error")
                }
                
                self.showingAlert.toggle()
                
                return
            }
            
            if authResult != nil {
                self.alertDescription = NSLocalizedString("accountCreated", comment: "Account created")
                self.showingAlert.toggle()
            }
        }
    }
    
    func continueWithFacebook(completionHandler: @escaping (Bool) -> Void) {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                completionHandler(false)
            case .cancelled:
                print("User cancelled login.")
                completionHandler(false)
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in! \(grantedPermissions) \(declinedPermissions) \(accessToken)")
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name"]).start(completionHandler: { (connection, result, error) in
                    if (error == nil){
                        let fbDetails = result as! NSDictionary
                        print(fbDetails)
                    }
                })
                
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        completionHandler(false)
                        return
                    }
                    completionHandler(true)
                    // User is signed in
                    // ...
                }
            }
        }
        
    }
}
