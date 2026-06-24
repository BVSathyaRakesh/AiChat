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
        try collection.document(user.userId).setData(from: user, merge: true)
    }
    
    func addUserListener(userId: String, onListenerAttached: (AnyObject) -> Void) -> AsyncStream<UserModel?> {
        AsyncStream { continuation in
            let listener = collection.document(userId).addSnapshotListener { documentSnapshot, _ in
                guard let document = documentSnapshot else {
                    continuation.yield(nil)
                    return
                }

                guard document.exists else {
                    continuation.yield(nil)
                    return
                }

                do {
                    let user = try document.data(as: UserModel.self)
                    continuation.yield(user)
                } catch {
                    continuation.yield(nil)
                }
            }
            onListenerAttached(listener)
        }
    }
    
    func deleteUser(userId: String) async throws {
        let document = collection.document(userId)
        let snapshot = try await document.getDocument()

        guard snapshot.exists else {
            throw UserServiceError.userNotFound
        }

        try await document.delete()
    }

    func updateOnboardingComplete(userId: String, profileColorHex: String) async throws {
        let document = collection.document(userId)
        let snapshot = try await document.getDocument()

        guard snapshot.exists else {
            throw UserServiceError.userNotFound
        }

        try await document.updateData([
            UserModel.CodingKeys.didCompleteOnBoarding.rawValue: true,
            UserModel.CodingKeys.profileColorHex.rawValue: profileColorHex
        ])
    }

}
