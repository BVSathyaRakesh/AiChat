//
//  AvatarManager.swift
//  AiChat
//
//  Created by Sathya Kumar on 30/06/26.
//

import SwiftUI

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
        return try await service.fetchUserAvatarsForAuthor(userId: userId)
    }

    func fetchFeaturedAvatars(limit: Int = 20) async throws -> [AvatarModal] {
        return try await service.fetchFeaturedAvatars(limit: limit)
    }

    func fetchPopularAvatars(limit: Int = 20) async throws -> [AvatarModal] {
        return try await service.fetchPopularAvatars(limit: limit)
    }
    
    func getAvatarForCategory(catergory: CharecterOption) async throws -> [AvatarModal] {
        return try await service.getAvatarsForcategory(category: catergory)
    }

    func deleteAvatar(avatarId: String) async throws {
        try await service.deleteAvatar(avatarId: avatarId)
    }

}
