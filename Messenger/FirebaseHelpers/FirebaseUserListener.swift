//
//  FirebaseUserListener.swift
//  Messenger
//
//  Created by Олег Федоров on 13.02.2022.
//

import Foundation
import Firebase

class FirebaseUserListener {
    
    typealias CompletionTypeLogin = (_ error: Error?, _ isEmailVerified: Bool) -> Void
    typealias CompletionTypeRegister = (_ error: Error?) -> Void
    
    static let shared = FirebaseUserListener()
    
    private init() {}
    
    // MARK: - Login
    func loginUserWithEmail(
        email: String, password: String, completion: @escaping CompletionTypeLogin
    ) {
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            guard let authDataResult = authDataResult else { return }
            
            if error == nil && authDataResult.user.isEmailVerified {
                self.downloadUserFromFirebase(
                    userId: authDataResult.user.uid, email: email
                )
                
                completion(error, true)
            } else {
                print("email is not verified")
                completion(error, false)
            }
        }
    }
    
    // MARK: - Register
    func registerUserWith(
        email: String, password: String, completion: @escaping CompletionTypeRegister
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
    
    // MARK: - Resend link methods
    func resendVerificationEmail(
        email: String, completion: @escaping CompletionTypeRegister
    ) {
        Auth.auth().currentUser?.reload { error in
            
            Auth.auth().currentUser?.sendEmailVerification { error in
                completion(error)
            }
        }
    }
    
    func resetPasswordFor(
        email: String, completion: @escaping CompletionTypeRegister
    ) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    // MARK: - Save users
    private func saveUserToFirestore(_ user: User) {
        do {
            try firebaseReference(.user).document(user.id).setData(from: user)
        } catch {
            print(error.localizedDescription, "adding user")
        }
    }
    
    // MARK: - Download user
    private func downloadUserFromFirebase(userId: String, email: String? = nil) {
        
        firebaseReference(.user).document(userId).getDocument { snapshot, error in
            guard let document = snapshot else {
                print("no document for user")
                return
            }
            
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
            case .success(let userObject):
                if let user = userObject {
                    saveUserLocally(user)
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding user ", error)
            }
        }
    }
}
