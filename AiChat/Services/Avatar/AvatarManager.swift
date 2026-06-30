//
//  AvatarManager.swift
//  AiChat
//
//  Created by Sathya Kumar on 30/06/26.
//

import FirebaseFirestore

protocol AvatarService {
    func createAvatar(avatar: AvatarModal) async throws
    func fetchUserAvatars(userId: String) async throws -> [AvatarModal]
    func fetchAvatar(avatarId: String) async throws -> AvatarModal?
    func fetchAllAvatars(limit: Int) async throws -> [AvatarModal]
    func deleteAvatar(avatarId: String) async throws
}

struct FirebaseAvatarService: AvatarService {

    var collection: CollectionReference {
        Firestore.firestore().collection("avatars")
    }

    func createAvatar(avatar: AvatarModal) async throws {
        try collection.document(avatar.avatarId).setData(from: avatar, merge: true)
    }

    func fetchUserAvatars(userId: String) async throws -> [AvatarModal] {
        let snapshot = try await collection
            .whereField("authorId", isEqualTo: userId)
            .order(by: "dateCreated", descending: true)
            .getDocuments()

        return try snapshot.documents.compactMap { doc in
            try doc.data(as: AvatarModal.self)
        }
    }

    func fetchAvatar(avatarId: String) async throws -> AvatarModal? {
        let doc = try await collection
            .document(avatarId)
            .getDocument()

        return try? doc.data(as: AvatarModal.self)
    }

    func fetchAllAvatars(limit: Int = 20) async throws -> [AvatarModal] {
        let snapshot = try await collection
            .order(by: "dateCreated", descending: true)
            .limit(to: limit)
            .getDocuments()

        return try snapshot.documents.compactMap { doc in
            try doc.data(as: AvatarModal.self)
        }
    }

    func deleteAvatar(avatarId: String) async throws {
        try await collection.document(avatarId).delete()
    }
}

struct MockAvatarService: AvatarService {
    func createAvatar(avatar: AvatarModal) async throws {
        print("Mock: Saved avatar \(avatar.name ?? "unnamed")")
    }

    func fetchUserAvatars(userId: String) async throws -> [AvatarModal] {
        return AvatarModal.mocks
    }

    func fetchAvatar(avatarId: String) async throws -> AvatarModal? {
        return AvatarModal.mock
    }

    func fetchAllAvatars(limit: Int) async throws -> [AvatarModal] {
        return AvatarModal.mocks
    }

    func deleteAvatar(avatarId: String) async throws {
        print("Mock: Deleted avatar \(avatarId)")
    }
}

@Observable
class AvatarManager {

    private let service: AvatarService

    init(service: AvatarService) {
        self.service = service
    }

    func saveAvatarData(avatarModel: AvatarModal) async throws {
        try await service.createAvatar(avatar: avatarModel)
    }

    func fetchUserAvatars(userId: String) async throws -> [AvatarModal] {
        return try await service.fetchUserAvatars(userId: userId)
    }

    func fetchAvatar(avatarId: String) async throws -> AvatarModal? {
        return try await service.fetchAvatar(avatarId: avatarId)
    }

    func fetchAllAvatars(limit: Int = 20) async throws -> [AvatarModal] {
        return try await service.fetchAllAvatars(limit: limit)
    }

    func deleteAvatar(avatarId: String) async throws {
        try await service.deleteAvatar(avatarId: avatarId)
    }

}
