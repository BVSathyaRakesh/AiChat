//
//  ChatMessageModal.swift
//  AiChat
//
//  Created by Sathya Kumar on 19/06/26.
//

import Foundation

struct ChatMessageModal: Identifiable {
    let id: String
    let chatId: String
    let authorId: String?
    let content: AIChatModel?  // Now stores AIChatModel instead of String
    let seenByIds: [String]?
    let dateCreated: Date

    var timeAgo: String {
        dateCreated.timeAgoDisplay()
    }

    var isFromCurrentUser: Bool {
        // This would typically check against actual current user ID
        authorId == "current-user-id"
    }

    func hasSeenBy(userId: String) -> Bool {
        guard let seenByIds else { return false }
        return seenByIds.contains(userId)
    }

    static var mock: ChatMessageModal {
        mocks[0]
    }

    static var mocks: [ChatMessageModal] = [
        // Chat 1 - Recent conversation
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-1",
            authorId: "current-user-id",
            content: .user("Hey! How are you doing today?"),
            seenByIds: ["avatar-1"],
            dateCreated: Date().addingTimeInterval(-60 * 30)
        ),
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-1",
            authorId: "avatar-1",
            content: .assistant("Hello! I'm doing great, thank you for asking. How about you?"),
            seenByIds: ["current-user-id"],
            dateCreated: Date().addingTimeInterval(-60 * 25)
        ),
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-1",
            authorId: "current-user-id",
            content: .user("I'm good! Just exploring this app."),
            seenByIds: [],
            dateCreated: Date().addingTimeInterval(-60 * 20)
        ),

        // Chat 2 - A few hours ago
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-2",
            authorId: "avatar-2",
            content: .assistant("Good morning! Ready for a new adventure?"),
            seenByIds: ["current-user-id"],
            dateCreated: Date().addingTimeInterval(-3600 * 5)
        ),
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-2",
            authorId: "current-user-id",
            content: .user("Absolutely! What do you have in mind?"),
            seenByIds: ["avatar-2"],
            dateCreated: Date().addingTimeInterval(-3600 * 4.5)
        ),
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-3",
            authorId: "avatar-3",
            content: .assistant("Of course! What do you need help with?"),
            seenByIds: ["current-user-id"],
            dateCreated: Date().addingTimeInterval(-86400 * 1.9)
        ),
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-3",
            authorId: "current-user-id",
            content: .user("I'm trying to understand how this works."),
            seenByIds: [],
            dateCreated: Date().addingTimeInterval(-86400 * 1.8)
        )
    ]
}
