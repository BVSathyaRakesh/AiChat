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
    let content: String?
    let seenByIds: [String]
    let dateCreated: Date

    var timeAgo: String {
        dateCreated.timeAgoDisplay()
    }

    var isFromCurrentUser: Bool {
        // This would typically check against actual current user ID
        authorId == "current-user-id"
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
            content: "Hey! How are you doing today?",
            seenByIds: ["avatar-1"],
            dateCreated: Date().addingTimeInterval(-60 * 30)
        ),
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-1",
            authorId: "avatar-1",
            content: "Hello! I'm doing great, thank you for asking. How about you?",
            seenByIds: ["current-user-id"],
            dateCreated: Date().addingTimeInterval(-60 * 25)
        ),
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-1",
            authorId: "current-user-id",
            content: "I'm good! Just exploring this app.",
            seenByIds: [],
            dateCreated: Date().addingTimeInterval(-60 * 20)
        ),

        // Chat 2 - A few hours ago
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-2",
            authorId: "avatar-2",
            content: "Good morning! Ready for a new adventure?",
            seenByIds: ["current-user-id"],
            dateCreated: Date().addingTimeInterval(-3600 * 5)
        ),
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-2",
            authorId: "current-user-id",
            content: "Absolutely! What do you have in mind?",
            seenByIds: ["avatar-2"],
            dateCreated: Date().addingTimeInterval(-3600 * 4.5)
        ),

        // Chat 3 - Yesterday
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-3",
            authorId: "current-user-id",
            content: "Can you help me with something?",
            seenByIds: ["avatar-3"],
            dateCreated: Date().addingTimeInterval(-86400 * 2)
        ),
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-3",
            authorId: "avatar-3",
            content: "Of course! What do you need help with?",
            seenByIds: ["current-user-id"],
            dateCreated: Date().addingTimeInterval(-86400 * 1.9)
        ),
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-3",
            authorId: "current-user-id",
            content: "I'm trying to understand how this works.",
            seenByIds: [],
            dateCreated: Date().addingTimeInterval(-86400 * 1.8)
        ),

        // Chat 4 - Several days ago
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-4",
            authorId: "avatar-4",
            content: "Hey there! Long time no chat!",
            seenByIds: ["current-user-id"],
            dateCreated: Date().addingTimeInterval(-86400 * 5)
        ),
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-4",
            authorId: "current-user-id",
            content: "Hi! Yeah, it's been a while. How have you been?",
            seenByIds: ["avatar-4"],
            dateCreated: Date().addingTimeInterval(-86400 * 4.9)
        ),

        // Chat 5 - Over a week ago
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-5",
            authorId: "current-user-id",
            content: "Thanks for all your help!",
            seenByIds: ["avatar-5"],
            dateCreated: Date().addingTimeInterval(-86400 * 10)
        ),
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: "chat-5",
            authorId: "avatar-5",
            content: "You're very welcome! Feel free to reach out anytime.",
            seenByIds: [],
            dateCreated: Date().addingTimeInterval(-86400 * 9.9)
        )
    ]
}
