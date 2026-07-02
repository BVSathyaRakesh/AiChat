//
//  MockLocalAvatarPersistance.swift
//  AiChat
//
//  Created by Sathya Kumar on 02/07/26.
//

struct MockLocalAvatarPersistance: LocalAvatarPersistance {
    func addRecentAvatar(avatarModel: AvatarModal) throws {
        
    }
    
    func getRecentAvtars() throws -> [AvatarModal] {
        return AvatarModal.mocks
    }
}
