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

    static var mocks: [ChatModal] = {
        let mockUserId = UserAuthInfo.mock().uid
        let avatars = AvatarModal.mocks

        return [
            // Recent active chat
            ChatModal(
                id: "\(mockUserId)_\(avatars[0].avatarId)",
                userId: mockUserId,
                avatarId: avatars[0].avatarId,
                dateCreated: Date().addingTimeInterval(-60 * 30),
                dateModified: Date().addingTimeInterval(-60 * 5),
                hasCreatedNew: false
            ),
            // Chat from earlier today
            ChatModal(
                id: "\(mockUserId)_\(avatars[1].avatarId)",
                userId: mockUserId,
                avatarId: avatars[1].avatarId,
                dateCreated: Date().addingTimeInterval(-3600 * 5),
                dateModified: Date().addingTimeInterval(-3600 * 2),
                hasCreatedNew: false
            ),
            // New chat from yesterday
            ChatModal(
                id: "\(mockUserId)_\(avatars[2].avatarId)",
                userId: mockUserId,
                avatarId: avatars[2].avatarId,
                dateCreated: Date().addingTimeInterval(-86400 * 1),
                dateModified: Date().addingTimeInterval(-86400 * 1),
                hasCreatedNew: true
            ),
            // Older chat
            ChatModal(
                id: "\(mockUserId)_\(avatars[3].avatarId)",
                userId: mockUserId,
                avatarId: avatars[3].avatarId,
                dateCreated: Date().addingTimeInterval(-86400 * 5),
                dateModified: Date().addingTimeInterval(-86400 * 4),
                hasCreatedNew: false
            ),
            // Very old chat
            ChatModal(
                id: "\(mockUserId)_\(avatars[4].avatarId)",
                userId: mockUserId,
                avatarId: avatars[4].avatarId,
                dateCreated: Date().addingTimeInterval(-86400 * 10),
                dateModified: Date().addingTimeInterval(-86400 * 9),
                hasCreatedNew: false
            )
        ]
    }()
}
