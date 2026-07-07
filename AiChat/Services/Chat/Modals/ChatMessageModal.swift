//
//  ChatMessageModal.swift
//  AiChat
//
//  Created by Sathya Kumar on 19/06/26.
//

import Foundation

struct ChatMessageModal: Identifiable, Codable {
    let id: String
    let chatId: String
    let authorId: String?
    let content: AIChatModel?  // Now stores AIChatModel instead of String
    let seenByIds: [String]?
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case chatId = "chat_id"
        case authorId = "author_id"
        case content
        case seenByIds = "seen_by_ids"
        case dateCreated = "date_created"
    }

    var timeAgo: String {
        dateCreated.timeAgoDisplay()
    }

    func isFromCurrentUser(userId: String) -> Bool {
        return authorId == userId
    }

    func hasSeenBy(userId: String) -> Bool {
        guard let seenByIds else { return false }
        return seenByIds.contains(userId)
    }

    // Factory methods for creating messages
    static func createUserMessage(
        chatId: String,
        authorId: String,
        text: String
    ) -> Self {
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: chatId,
            authorId: authorId,
            content: .user(text),
            seenByIds: nil,
            dateCreated: .now
        )
    }

    static func createAssistantMessage(
        chatId: String,
        authorId: String,
        text: String
    ) -> Self {
        ChatMessageModal(
            id: UUID().uuidString,
            chatId: chatId,
            authorId: authorId,
            content: .assistant(text),
            seenByIds: nil,
            dateCreated: .now
        )
    }

    static var mock: ChatMessageModal {
        mocks[0]
    }

    static var mocks: [ChatMessageModal] = {
        let mockUserId = UserAuthInfo.mock().uid
        let mockAvatarId = AvatarModal.mock.avatarId
        let chatId = "\(mockUserId)_\(mockAvatarId)"

        return [
            // Recent conversation - realistic flow
            ChatMessageModal(
                id: UUID().uuidString,
                chatId: chatId,
                authorId: mockUserId,
                content: .user("Hey! How are you doing today?"),
                seenByIds: [mockAvatarId],
                dateCreated: Date().addingTimeInterval(-60 * 15)
            ),
            ChatMessageModal(
                id: UUID().uuidString,
                chatId: chatId,
                authorId: mockAvatarId,
                content: .assistant("Hello! I'm doing great, thank you for asking. How about you?"),
                seenByIds: [mockUserId],
                dateCreated: Date().addingTimeInterval(-60 * 14)
            ),
            ChatMessageModal(
                id: UUID().uuidString,
                chatId: chatId,
                authorId: mockUserId,
                content: .user("I'm good! Just exploring this app."),
                seenByIds: [mockAvatarId],
                dateCreated: Date().addingTimeInterval(-60 * 13)
            ),
            ChatMessageModal(
                id: UUID().uuidString,
                chatId: chatId,
                authorId: mockAvatarId,
                content: .assistant("That's wonderful! I'm here to help you explore and answer any questions you might have. What would you like to know?"),
                seenByIds: [mockUserId],
                dateCreated: Date().addingTimeInterval(-60 * 12)
            ),
            ChatMessageModal(
                id: UUID().uuidString,
                chatId: chatId,
                authorId: mockUserId,
                content: .user("Can you tell me what features are available?"),
                seenByIds: [mockAvatarId],
                dateCreated: Date().addingTimeInterval(-60 * 10)
            ),
            ChatMessageModal(
                id: UUID().uuidString,
                chatId: chatId,
                authorId: mockAvatarId,
                content: .assistant("Sure! You can chat with various AI characters, create custom avatars, and have engaging conversations. Each character has unique personalities and can help with different topics!"),
                seenByIds: [],
                dateCreated: Date().addingTimeInterval(-60 * 9)
            ),
            ChatMessageModal(
                id: UUID().uuidString,
                chatId: chatId,
                authorId: mockUserId,
                content: .user("That sounds amazing! Thanks for explaining."),
                seenByIds: [],
                dateCreated: Date().addingTimeInterval(-60 * 5)
            )
        ]
    }()

    // Preview-specific mocks
    static var previewConversation: [ChatMessageModal] {
        let mockUserId = UserAuthInfo.mock().uid
        let mockAvatarId = AvatarModal.mock.avatarId
        let chatId = "\(mockUserId)_\(mockAvatarId)"

        return [
            ChatMessageModal(
                id: UUID().uuidString,
                chatId: chatId,
                authorId: mockUserId,
                content: .user("Hello! How are you?"),
                seenByIds: [mockAvatarId],
                dateCreated: Date().addingTimeInterval(-60 * 20) // 20 minutes ago
            ),
            ChatMessageModal(
                id: UUID().uuidString,
                chatId: chatId,
                authorId: mockAvatarId,
                content: .assistant("Hi! I'm doing great, thanks for asking! How can I help you today?"),
                seenByIds: [mockUserId],
                dateCreated: Date().addingTimeInterval(-60 * 14) // 14 minutes ago (6 minutes later)
            ),
            ChatMessageModal(
                id: UUID().uuidString,
                chatId: chatId,
                authorId: mockUserId,
                content: .user("Can you tell me about the weather?"),
                seenByIds: [],
                dateCreated: Date().addingTimeInterval(-60 * 2) // 2 minutes ago (12 minutes later)
            )
        ]
    }

    static var previewAIGenerating: [ChatMessageModal] {
        let mockUserId = UserAuthInfo.mock().uid
        let mockAvatarId = AvatarModal.mock.avatarId
        let chatId = "\(mockUserId)_\(mockAvatarId)"

        return [
            ChatMessageModal(
                id: UUID().uuidString,
                chatId: chatId,
                authorId: mockUserId,
                content: .user("What's the capital of India?"),
                seenByIds: [],
                dateCreated: Date().addingTimeInterval(-5)
            ),
            ChatMessageModal(
                id: "thinking-indicator",
                chatId: chatId,
                authorId: mockAvatarId,
                content: .assistant("..."),
                seenByIds: [],
                dateCreated: .now
            )
        ]
    }
}
