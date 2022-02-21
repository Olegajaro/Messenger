//
//  User.swift
//  Messenger
//
//  Created by Олег Федоров on 13.02.2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Codable, Equatable {
    var id = ""
    var userName: String
    var email: String
    var pushId = ""
    var avatarLink = ""
    var status: String
    
    static var currentId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.data(forKey: KEY_CURRENT_USER) {
                
                let decoder = JSONDecoder()
                
                do {
                    let object = try decoder.decode(User.self, from: dictionary)
                    return object
                } catch {
                    print("Error decoding user from user defaults", error.localizedDescription)
                }
            }
        }
        
        return nil
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

func saveUserLocally(_ user: User) {
    
    let encoder = JSONEncoder()
    
    do {
        let data = try encoder.encode(user)
        UserDefaults.standard.set(data, forKey: KEY_CURRENT_USER)
    } catch {
        print("Error saving user locally ", error.localizedDescription)
    }
    
}

func createDummyUsers() {
    print("DEBUG: creating dummy users...")
    let names = ["John Snow", "Rob Stark",
                 "Sansa Stark", "Stiven Sigal",
                 "Chuck Norris", "Mr. Bean"]
    
    var imageIndex = 1
    var userIndex = 1
    
    for index in 0..<6 {
        
        let id = UUID().uuidString
        
        let fileDirectory = "Avatars/" + "_\(id)" + ".jpg"
        
        FileStorage.uploadImage(
            UIImage(named: "user\(imageIndex)")!,
            directory: fileDirectory) { avatarLink in
                
                let user = User(
                    id: id, userName: names[index],
                    email: "user\(userIndex)@gmail.com",
                    pushId: "", avatarLink: avatarLink ?? "",
                    status: "No status")
                
                userIndex += 1
                
                FirebaseUserListener.shared.saveUserToFirestore(user)
            }
        
        imageIndex += 1
        
        if imageIndex == 6 {
            imageIndex = 1
        }
    }
}
