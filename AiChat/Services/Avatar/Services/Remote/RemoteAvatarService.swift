//
//  AvatarService.swift
//  AiChat
//
//  Created by Sathya Kumar on 02/07/26.
//

protocol RemoteAvatarService {
    func createAvatar(avatar: AvatarModal) async throws
    func getAvatarById(avatarId: String) async throws -> AvatarModal
    func fetchUserAvatarsForAuthor(userId: String) async throws -> [AvatarModal]
    func fetchFeaturedAvatars(limit: Int) async throws -> [AvatarModal]
    func fetchPopularAvatars(limit: Int) async throws -> [AvatarModal]
    func fetchAllAvatars(limit: Int) async throws -> [AvatarModal]
    func getAvatarsForcategory(category: CharecterOption) async throws -> [AvatarModal]
    func deleteAvatar(avatarId: String) async throws
    func incrementClickCount(avatarId: String) async throws
}
