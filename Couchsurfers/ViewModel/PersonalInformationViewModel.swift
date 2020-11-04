//
//  PersonalInformationViewModel.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 30..
//

import Foundation
import Firebase

class PersonalInformationViewModel: ObservableObject {
    
    func loadUserInformation(completionHandler: @escaping (User?, Error?) -> Void) {
        let userRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
        
        userRef.getDocument { (document, error) in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let user):
                if let user = user {
                    completionHandler(user, nil)
                } else {
                    completionHandler(nil, CustomError(msg: "Document does not exist"))
                }
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func saveUserInformation(firstName: String, lastName: String, gender: Int, phone: String) {
        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData([
            "firstName": firstName,
            "lastName": lastName,
            "phone": phone,
            "gender": gender
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document updated with ID: \(Auth.auth().currentUser!.uid)")
            }
        }
    }
}
