//
//  DefaultAvatarRepository.swift
//  AiChat
//
//  Created by Sathya Kumar on 09/07/26.
//

import SwiftUI

final class RemoteAvatarRepository: AvatarRepositoryProtocol {
    
    // MARK: - Dependencies
    private let avatarManager: AvatarManager
    
    // MARK: - Initialization
    init(avatarManager: AvatarManager) {
        self.avatarManager = avatarManager
    }
    
    // MARK: - AvatarRepositoryProtocol Implementation
    
    func fetchUserAvatarsForAuthor(userId: String) async throws -> [AvatarModal] {
        // Delegate to existing manager
        return try await avatarManager.fetchUserAvatars(userId: userId)
    }
    
    func deleteAvatar(avatarId: String) async throws {
        // Delegate to existing manager
        try await avatarManager.deleteAvatar(avatarId: avatarId)
    }
    
    func getAvatarById(avatarId: String) async throws -> AvatarModal {
        // Delegate to existing manager
        return try await avatarManager.getAvatarById(avatarId: avatarId)
    }
    
    func incrementClickCount(avatarId: String) async throws {
        // Delegate to existing manager
        try await avatarManager.incrementClickCount(avatarId: avatarId)
    }
    
}
