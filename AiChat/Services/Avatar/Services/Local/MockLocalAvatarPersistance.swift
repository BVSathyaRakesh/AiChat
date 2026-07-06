//
//  MockLocalAvatarPersistence.swift
//  AiChat
//
//  Created by Sathya Kumar on 02/07/26.
//

struct MockLocalAvatarPersistence: LocalAvatarPersistence {
    var avatars: [AvatarModal] = AvatarModal.mocks

    func addRecentAvatar(avatarModel: AvatarModal) throws {

    }

    func getRecentAvtars() throws -> [AvatarModal] {
        return avatars
    }
}
