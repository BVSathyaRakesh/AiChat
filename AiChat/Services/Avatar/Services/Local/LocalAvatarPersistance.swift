//
//  LocalAvatarPersistance.swift
//  AiChat
//
//  Created by Sathya Kumar on 02/07/26.
//

protocol LocalAvatarPersistance {
    func addRecentAvatar(avatarModel: AvatarModal) throws
    func getRecentAvtars() throws -> [AvatarModal]
}
