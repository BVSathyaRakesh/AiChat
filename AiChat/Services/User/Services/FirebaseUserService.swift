//
//  FirebaseUserService.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//

import FirebaseFirestore

struct FirebaseUserService: UserService {
    
    var collection: CollectionReference {
        Firestore.firestore().collection("users")
    }
    
    func saveUser(user: UserModel) async throws {
        try  collection.document(user.userId).setData(from: user, merge: true)
    }
}
