//
//  AvatarManager.swift
//  AiChat
//
//  Created by Sathya Kumar on 30/06/26.
//

import SwiftUI

@Observable
class AvatarManager {

    private let remote: RemoteAvatarService
    private let local: LocalAvatarPersistence

    init(service: RemoteAvatarService, local: LocalAvatarPersistence = MockLocalAvatarPersistence()) {
        self.remote = service
        self.local = local
    }
    
    func addRecentAvatar(avatarModel: AvatarModal) async throws {
        try local.addRecentAvatar(avatarModel: avatarModel)
        try await remote.incrementClickCount(avatarId: avatarModel.avatarId)
    }
    
    func getRecentAvatars() async throws -> [AvatarModal] {
        try local.getRecentAvtars()
    }

    func saveAvatarData(avatarModel: AvatarModal) async throws {
        try await remote.createAvatar(avatar: avatarModel)
    }

    func fetchUserAvatars(userId: String) async throws -> [AvatarModal] {
        return try await remote.fetchUserAvatarsForAuthor(userId: userId)
    }

    func getAvatarById(avatarId: String) async throws -> AvatarModal {
        return try await remote.getAvatarById(avatarId: avatarId)
    }

    func fetchFeaturedAvatars(limit: Int = 20) async throws -> [AvatarModal] {
        return try await remote.fetchFeaturedAvatars(limit: limit)
    }

    func fetchPopularAvatars(limit: Int = 20) async throws -> [AvatarModal] {
        return try await remote.fetchPopularAvatars(limit: limit)
    }

    func fetchAllAvatars(limit: Int = 20) async throws -> [AvatarModal] {
        return try await remote.fetchAllAvatars(limit: limit)
    }
    
    func getAvatarForCategory(catergory: CharecterOption) async throws -> [AvatarModal] {
        return try await remote.getAvatarsForcategory(category: catergory)
    }

    func deleteAvatar(avatarId: String) async throws {
        try await remote.deleteAvatar(avatarId: avatarId)
    }

    func incrementClickCount(avatarId: String) async throws {
        try await remote.incrementClickCount(avatarId: avatarId)
    }

}
