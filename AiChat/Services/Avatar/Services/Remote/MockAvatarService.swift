//
//  MockAvatarService.swift
//  AiChat
//
//  Created by Sathya Kumar on 02/07/26.
//

import Foundation

struct MockAvatarService: RemoteAvatarService {
    func createAvatar(avatar: AvatarModal) async throws {
        print("Mock: Saved avatar \(avatar.name ?? "unnamed")")
    }

    func getAvatarById(avatarId: String) async throws -> AvatarModal {
        guard let avatar = AvatarModal.mocks.first(where: { $0.avatarId == avatarId }) else {
            throw NSError(domain: "AvatarService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Avatar not found"])
        }
        return avatar
    }

    func fetchUserAvatarsForAuthor(userId: String) async throws -> [AvatarModal] {
        return AvatarModal.mocks
    }

    func fetchFeaturedAvatars(limit: Int) async throws -> [AvatarModal] {
        return Array(AvatarModal.mocks.prefix(limit))
    }

    func fetchPopularAvatars(limit: Int) async throws -> [AvatarModal] {
        return Array(AvatarModal.mocks.prefix(limit))
    }
    
    func getAvatarsForcategory(category: CharecterOption) async throws -> [AvatarModal] {
        return Array(AvatarModal.mocks.prefix(1))
    }
    
    func deleteAvatar(avatarId: String) async throws {
        print("Mock: Deleted avatar \(avatarId)")
    }
}
