//
//  AvatarEntity.swift
//  AiChat
//
//  Created by Sathya Kumar on 02/07/26.
//

import SwiftUI
import SwiftData

@Model
class AvatarEntity {
    
    @Attribute(.unique) var avatarId: String
    var name: String?
    var charcterOption: CharecterOption?
    var charcterAction: CharecterAction?
    var charcetrLocation: CharcterLocation?
    var profileImageName: String?
    var authorId: String?
    var dateCreated: Date?
    var dateAdded: Date
    
    init(from model: AvatarModal) {
        self.avatarId = model.avatarId
        self.name = model.name
        self.charcterOption = model.charcterOption
        self.charcterAction = model.charcterAction
        self.charcetrLocation = model.charcetrLocation
        self.profileImageName = model.profileImageName
        self.authorId = model.authorId
        self.dateCreated = model.dateCreated
        self.dateAdded = .now
    }
    
    func toModel() -> AvatarModal {
        AvatarModal(
            avatarId: avatarId,
            name: name,
            charcterOption: charcterOption,
            charcterAction: charcterAction,
            charcetrLocation: charcetrLocation,
            profileImageName: profileImageName,
            authorId: authorId,
            dateCreated: dateCreated
        )
    }
}
