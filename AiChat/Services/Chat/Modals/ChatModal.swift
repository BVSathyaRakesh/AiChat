//
//  ChatModal.swift
//  AiChat
//
//  Created by Sathya Kumar on 19/06/26.
//

import Foundation

struct ChatModal: Identifiable {
    let id: String
    let userId: String
    let avatarId: String
    let dateCreated: Date
    
    
    init(
        id: String,
        userId: String,
        avatarId: String,
        dateCreated: Date
    ) {
        self.id = id
        self.userId = userId
        self.avatarId = avatarId
        self.dateCreated = dateCreated
    }

    var timeAgo: String {
        dateCreated.timeAgoDisplay()
    }

    static var mock: ChatModal {
        mocks[0]
    }

    static var mocks: [ChatModal] = [
        ChatModal(id: "mock-chat_1", userId: UUID().uuidString, avatarId: UUID().uuidString, dateCreated: Date().addingTimeInterval(-60 * 30)),
        ChatModal(id: "mock-chat_2", userId: UUID().uuidString, avatarId: UUID().uuidString, dateCreated: Date().addingTimeInterval(-3600 * 5)),
        ChatModal(id: "mock-chat_3", userId: UUID().uuidString, avatarId: UUID().uuidString, dateCreated: Date().addingTimeInterval(-86400 * 2)),
        ChatModal(id: "mock-chat_4", userId: UUID().uuidString, avatarId: UUID().uuidString, dateCreated: Date().addingTimeInterval(-86400 * 5)),
        ChatModal(id: "mock-chat_5", userId: UUID().uuidString, avatarId: UUID().uuidString, dateCreated: Date().addingTimeInterval(-86400 * 10))
    ]
}
