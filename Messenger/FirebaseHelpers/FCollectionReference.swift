//
//  FCollectionReference.swift
//  Messenger
//
//  Created by Олег Федоров on 13.02.2022.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case user = "User"
    case recent = "Recent"
}

func firebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
