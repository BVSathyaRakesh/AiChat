//
//  MockAvatarService.swift
//  AiChat
//
//  Created by Sathya Kumar on 02/07/26.
//


struct MockAvatarService: AvatarService {
    func createAvatar(avatar: AvatarModal) async throws {
        print("Mock: Saved avatar \(avatar.name ?? "unnamed")")
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