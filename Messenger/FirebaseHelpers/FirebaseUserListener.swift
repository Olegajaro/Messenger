//
//  FirebaseUserListener.swift
//  Messenger
//
//  Created by Олег Федоров on 13.02.2022.
//

import Foundation
import Firebase

class FirebaseUserListener {
    
    typealias CompletionType = (_ error: Error?) -> Void
    
    static let shared = FirebaseUserListener()
    
    private init() {}
    
    // MARK: - Login
    
    // MARK: - Register
    func registerUserWith(
        email: String, password: String, completion: @escaping CompletionType
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { dataResult, error in
            guard let dataResult = dataResult else { return }
            
            completion(error)
            
            if error == nil {
                // send verification email
                dataResult.user.sendEmailVerification { error in
                    print("auth email sent with error: ", error?.localizedDescription ?? "")
                }
                
                // create user and save it
                let user = User(
                    id: dataResult.user.uid, userName: email,
                    email: email, pushId: "",
                    avatarLink: "", status: "Hey there I'm using messenger"
                )
            }
        }
    }
}
