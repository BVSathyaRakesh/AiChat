//
//  AvatarAttributes.swift
//  AiChat
//
//  Created by Sathya Kumar on 21/06/26.
//

enum CharecterOption: String, CaseIterable, Hashable, Codable {
    case man, woman, cat, dog, alien

    static var `default`: Self {
        .man
    }

    var plural: String {
        switch self {
        case .man:
            return "men"
        case .woman:
            return "women"
        default:
            return rawValue + "s"
        }
    }

    var startsWithVowel: Bool {
        switch self {
        case .alien:
            return true
        default:
            return false
        }
    }
}

enum CharecterAction: String, CaseIterable, Codable {
    case smiling, sitting, standing, walking, running, eating, drinking, working, crying, relaxing, fighting

    static var `default`: Self {
        .smiling
    }
}

enum CharcterLocation: String, CaseIterable, Codable {
    case park, mall, musem, city, desert, forest, space

    static var `default`: Self {
        .park
    }
}

struct AvatarDescriptionBuilder {
    let charecterOption: CharecterOption
    let charecterAction: CharecterAction
    let charceterLocation: CharcterLocation
    
    init(charecterOption: CharecterOption, charecterAction: CharecterAction, charceterLocation: CharcterLocation) {
        self.charecterOption = charecterOption
        self.charecterAction = charecterAction
        self.charceterLocation = charceterLocation
    }
    
    init(avatar: AvatarModal) {
        self.charecterOption = avatar.charcterOption ?? .default
        self.charecterAction = avatar.charcterAction ?? .default
        self.charceterLocation = avatar.charcetrLocation ?? .default
    }
    
    var charcterDescription: String {
        let prefix = charecterOption.startsWithVowel ? "An" : "A"
        return "\(prefix) \(charecterOption.rawValue) that is \(charecterAction.rawValue) in the \(charceterLocation.rawValue)"
    }
}
