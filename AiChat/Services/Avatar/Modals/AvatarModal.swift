//
//  AvatarModal.swift
//  AiChat
//
//  Created by Sathya Kumar on 17/06/26.
//

import Foundation

struct AvatarModal: Hashable {
    let avatarId: String
    let name: String?
    let charcterOption: CharecterOption?
    let charcterAction: CharecterAction?
    let charcetrLocation: CharcterLocation?
    let profileImageName: String?
    let authorId: String?
    let dateCreated: Date?
    
    init(
        avatarId: String,
        name: String? = nil,
        charcterOption: CharecterOption? = nil,
        charcterAction: CharecterAction? = nil,
        charcetrLocation: CharcterLocation? = nil,
        profileImageName: String? = nil,
        authorId: String? = nil,
        dateCreated: Date? = nil
    ) {
        self.avatarId = avatarId
        self.name = name
        self.charcterOption = charcterOption
        self.charcterAction = charcterAction
        self.charcetrLocation = charcetrLocation
        self.profileImageName = profileImageName
        self.authorId = authorId
        self.dateCreated = dateCreated
    }
    
    var charecterDescription: String {
        AvatarDescriptionBuilder(avatar: self).charcterDescription
    }
    
    static var mock: AvatarModal {
        mocks[0]
    }
    
    static var mocks: [AvatarModal] = [
        AvatarModal(avatarId: UUID().uuidString, name: "Alpha", charcterOption: .alien, charcterAction: .smiling, charcetrLocation: .park, profileImageName: Constants.randomImage, authorId: UUID().uuidString, dateCreated: .now),
        AvatarModal(avatarId: UUID().uuidString, name: "Beta", charcterOption: .dog, charcterAction: .eating, charcetrLocation: .city, profileImageName: Constants.randomImage, authorId: UUID().uuidString, dateCreated: .now),
        AvatarModal(avatarId: UUID().uuidString, name: "Gama", charcterOption: .cat, charcterAction: .drinking, charcetrLocation: .desert, profileImageName: Constants.randomImage, authorId: UUID().uuidString, dateCreated: .now),
        AvatarModal(avatarId: UUID().uuidString, name: "Delta", charcterOption: .woman, charcterAction: .fighting, charcetrLocation: .musem, profileImageName: Constants.randomImage, authorId: UUID().uuidString, dateCreated: .now),
        AvatarModal(avatarId: UUID().uuidString, name: "Alpha1", charcterOption: .man, charcterAction: .relaxing, charcetrLocation: .mall, profileImageName: Constants.randomImage, authorId: UUID().uuidString, dateCreated: .now)
    ]
}

