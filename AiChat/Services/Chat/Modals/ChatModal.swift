//
//  ChatModal.swift
//  AiChat
//
//  Created by Sathya Kumar on 19/06/26.
//

import Foundation

struct ChatModal: Identifiable, Hashable, Codable {
    let id: String
    let userId: String
    let avatarId: String
    let dateCreated: Date
    let dateModified: Date
    let hasCreatedNew: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case avatarId = "avatar_id"
        case dateCreated = "date_created"
        case dateModified = "date_modified"
        case hasCreatedNew = "has_created_new"
    }
    
   static func new(userId: String, avatarId: String) -> Self {
        ChatModal(
            id: "\(userId)_\(avatarId)",
            userId: userId,
            avatarId: avatarId,
            dateCreated: .now,
            dateModified: .now,
            hasCreatedNew: true
        )
    }

    var timeAgo: String {
        dateCreated.timeAgoDisplay()
    }

    static var mock: ChatModal {
        mocks[0]
    }

    static var mocks: [ChatModal] = [
        ChatModal(id: "mock-chat_1", userId: UUID().uuidString, avatarId: UUID().uuidString, dateCreated: Date().addingTimeInterval(-60 * 30), dateModified: Date().addingTimeInterval(-60 * 30), hasCreatedNew: false),
        ChatModal(id: "mock-chat_2", userId: UUID().uuidString, avatarId: UUID().uuidString, dateCreated: Date().addingTimeInterval(-3600 * 5), dateModified: Date().addingTimeInterval(-60 * 30), hasCreatedNew: false),
        ChatModal(id: "mock-chat_3", userId: UUID().uuidString, avatarId: UUID().uuidString, dateCreated: Date().addingTimeInterval(-86400 * 2), dateModified: Date().addingTimeInterval(-60 * 30), hasCreatedNew: true),
        ChatModal(id: "mock-chat_4", userId: UUID().uuidString, avatarId: UUID().uuidString, dateCreated: Date().addingTimeInterval(-86400 * 5), dateModified: Date().addingTimeInterval(-60 * 30), hasCreatedNew: false),
        ChatModal(id: "mock-chat_5", userId: UUID().uuidString, avatarId: UUID().uuidString, dateCreated: Date().addingTimeInterval(-86400 * 10), dateModified: Date().addingTimeInterval(-60 * 30), hasCreatedNew: false)
    ]
}
