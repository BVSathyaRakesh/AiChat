//
//  FirebaseAvatarService.swift
//  AiChat
//
//  Created by Sathya Kumar on 02/07/26.
//

import FirebaseFirestore

extension QuerySnapshot {
    func decode<T: Decodable>(as type: T.Type) throws -> [T] {
        return try documents.compactMap { try $0.data(as: type) }
    }
}

struct FirebaseAvatarService: RemoteAvatarService {

    var collection: CollectionReference {
        Firestore.firestore().collection("avatars")
    }
    
    func createAvatar(avatar: AvatarModal) async throws {
        try collection.document(avatar.avatarId).setData(from: avatar, merge: true)
    }

    func fetchUserAvatarsForAuthor(userId: String) async throws -> [AvatarModal] {
        let snapshot = try await collection
            .whereField(AvatarModal.CodingKeys.authorId.rawValue, isEqualTo: userId)
            .getDocuments()

        let avatars = try snapshot.decode(as: AvatarModal.self)
        return avatars.sorted {
            ($0.dateCreated ?? .distantPast) > ($1.dateCreated ?? .distantPast)
        }
    }
    
    func getAvatarById(avatarId: String) async throws -> AvatarModal {
        let document = try await collection
            .document(avatarId)
            .getDocument()

        guard let avatar = try? document.data(as: AvatarModal.self) else {
            throw NSError(domain: "AvatarService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Avatar not found"])
        }

        return avatar
    }

    func fetchFeaturedAvatars(limit: Int = 20) async throws -> [AvatarModal] {
        let snapshot = try await collection
            .limit(to: limit)
            .getDocuments()

        return try snapshot.decode(as: AvatarModal.self)
    }

    func fetchPopularAvatars(limit: Int = 200) async throws -> [AvatarModal] {
        let snapshot = try await collection
            .whereField(AvatarModal.CodingKeys.clickCount.rawValue, isGreaterThan: 0)
            .order(by: AvatarModal.CodingKeys.clickCount.rawValue, descending: true)
            .limit(to: limit)
            .getDocuments()

        return try snapshot.decode(as: AvatarModal.self)
    }

    func fetchAllAvatars(limit: Int = 200) async throws -> [AvatarModal] {
        let snapshot = try await collection
            .limit(to: limit)
            .getDocuments()

        return try snapshot.decode(as: AvatarModal.self)
    }
    
    func getAvatarsForcategory(category: CharecterOption) async throws -> [AvatarModal] {
        let snapshot = try await collection
            .whereField(AvatarModal.CodingKeys.charcterOption.rawValue, isEqualTo: category.rawValue)
            .getDocuments()

        return try snapshot.decode(as: AvatarModal.self)
    }

    func deleteAvatar(avatarId: String) async throws {
        try await collection.document(avatarId).delete()
    }

    func incrementClickCount(avatarId: String) async throws {
        try await collection.document(avatarId).updateData([
            AvatarModal.CodingKeys.clickCount.rawValue: FieldValue.increment(Int64(1))
        ])
    }
}
