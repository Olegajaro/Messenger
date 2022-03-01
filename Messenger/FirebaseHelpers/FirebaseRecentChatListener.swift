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
    
    // MARK: - Download recent chats
    func downloadRecentChatsFromFirestore(
        completion: @escaping(_ allRecents: [RecentChat]) -> Void
    ) {
        firebaseReference(.recent).whereField(
            KEY_SENDER_ID,
            isEqualTo: User.currentId
        ).addSnapshotListener { snapshot, error in
            
            var recentChats: [RecentChat] = []
            
            guard let documents = snapshot?.documents else {
                print("DEBUG: no documents for recent chats")
                return
            }
            
            let allRecents = documents.compactMap { queryDocumentSnapshot -> RecentChat? in
                return try? queryDocumentSnapshot.data(as: RecentChat.self)
            }
            
            for recent in allRecents {
                if recent.lastMessage != "" {
                    recentChats.append(recent)
                }
            }
            
            recentChats.sort { $0.date! > $1.date! }
            completion(recentChats)
        }
    }
    
    // MARK: - Add recent chat
    func addRecent(_ recent: RecentChat) {
        
        do {
            try firebaseReference(.recent).document(recent.id).setData(from: recent)
        } catch {
            print("Error saving recent chat ", error.localizedDescription)
        }
    }
}
