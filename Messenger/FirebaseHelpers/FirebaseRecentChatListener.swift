//
//  FirebaseRecentChatListener.swift
//  Messenger
//
//  Created by Олег Федоров on 28.02.2022.
//

import Foundation
import Firebase

class FirebaseRecentChatListener {
    
    static let shared = FirebaseRecentChatListener()
    private init() { }
    
    func addRecent(_ recent: RecentChat) {
        
        do {
            try firebaseReference(.recent).document(recent.id).setData(from: recent)
        } catch {
            print("Error saving recent chat ", error.localizedDescription)
        }
    }
}
