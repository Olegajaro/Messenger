//
//  FirebaseUserListener.swift
//  Messenger
//
//  Created by Олег Федоров on 13.02.2022.
//

import Foundation
import Firebase
import UIKit

class FirebaseUserListener {
    
    typealias CompletionTypeLogin = (_ error: Error?, _ isEmailVerified: Bool) -> Void
    typealias CompletionTypeRegister = (_ error: Error?) -> Void
    typealias CompletionTypeUsers = (_ allUsers: [User]) -> Void
    
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
    
    // MARK: - Log Out
    func logOutCurrentUser(completion: @escaping CompletionTypeRegister) {
        
        do {
            try Auth.auth().signOut()
            
            userDefaults.removeObject(forKey: KEY_CURRENT_USER)
            userDefaults.synchronize()
            
            completion(nil)
        } catch let error {
            completion(error)
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
    
    // MARK: - Download all users
    func downloadAllUsersFromFirebase(completion: @escaping CompletionTypeUsers) {
        
        var users: [User] = []
        
        firebaseReference(.user).limit(to: 500).getDocuments { snapshot, error in
            
            guard let document = snapshot?.documents else {
                print("no documents in all users")
                return
            }
            
            let allUsers = document.compactMap { queryDocumentSnapshot -> User? in
                
                return try? queryDocumentSnapshot.data(as: User.self)
            }
            
            for user in allUsers {
                if User.currentId != user.id {
                    users.append(user)
                }
            }
            
            completion(users)
        }
    }
    
    func downloadUserFromFirebase(
        withIds: [String],
        completion: @escaping CompletionTypeUsers
    ) {
        var count = 0
        var usersArray: [User] = []
        
        for userId in withIds {
            
            firebaseReference(.user).document(userId).getDocument { snapshot, error in
                
                guard
                    let document = snapshot,
                    let user = try? document.data(as: User.self)
                else {
                    print("no documents in all users")
                    return
                }
                
                usersArray.append(user)
                count += 1
                
                if count == withIds.count {
                    completion(usersArray)
                }
            }
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
