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
        Auth.auth().createUser(
            withEmail: email, password: password
        ) { authDataResult, error in
            guard let authDataResult = authDataResult else { return }
            
            completion(error)
            
            if error == nil {
                // send verification email
                authDataResult.user.sendEmailVerification { error in
                    print("auth email sent with error: ", error?.localizedDescription ?? "")
                }
                
                // create user and save it
                let user = User(
                    id: authDataResult.user.uid, userName: email,
                    email: email, pushId: "",
                    avatarLink: "", status: "Hey there I'm using messenger"
                )
                
                saveUserLocally(user)
                self.saveUserToFirestore(user)
            }
        }
    }
    
    // MARK: - Save users
    func saveUserToFirestore(_ user: User) {
        do {
            try firebaseReference(.user).document(user.id).setData(from: user)
        } catch {
            print(error.localizedDescription, "adding user")
        }
    }
}
