//
//  AvatarRepositoryProtocol.swift
//  AiChat
//
//  Created by Sathya Kumar on 09/07/26.
//

/// Repository protocol for Avatar data access
/// Domain layer defines the contract, Data layer implements it
protocol AvatarRepositoryProtocol {
    func fetchUserAvatarsForAuthor(userId: String) async throws -> [AvatarModal]
    func deleteAvatar(avatarId: String) async throws
    func getAvatarById(avatarId: String) async throws -> AvatarModal
    func incrementClickCount(avatarId: String) async throws
}
