//
//  MockChatMessageService.swift
//  AiChat
//
//  Created by Sathya Kumar on 07/07/26.
//
import SwiftUI
import FirebaseFirestore

struct MockChatMessageService: ChatService {
    var chats: [ChatModal] = ChatModal.mocks
    var delay: CGFloat = 0

    private func simulateDelay() async {
        if delay > 0 {
            try? await Task.sleep(for: .seconds(delay))
        }
    }

    func createNewChat(chat: ChatModal) async throws {
        await simulateDelay()
        print("Mock: Created chat \(chat.id)")
    }

    func getChat(chatId: String) async throws -> ChatModal? {
        await simulateDelay()
        return chats.first(where: { $0.id == chatId })
    }

    func getUserChats(userId: String) async throws -> [ChatModal] {
        await simulateDelay()
        return chats.filter { $0.userId == userId }
    }

    func getChatMessages(chatId: String) async throws -> [ChatMessageModal] {
        await simulateDelay()
        return ChatMessageModal.mocks.filter { $0.chatId == chatId }
    }

    func getLastMessage(chatId: String) async throws -> ChatMessageModal? {
        await simulateDelay()
        return ChatMessageModal.mocks.filter { $0.chatId == chatId }
            .sorted { $0.dateCreated > $1.dateCreated }
            .first
    }

    func addChatMessage(chatId: String, message: ChatMessageModal) async throws {
        await simulateDelay()
        print("Mock: Added message to chat \(chatId)")
    }

    func markMessageAsSeen(chatId: String, messageId: String, userId: String) async throws {
        await simulateDelay()
        print("Mock: Marked message \(messageId) as seen by user \(userId)")
    }

    func deleteChatMessages(chatId: String) async throws {
        await simulateDelay()
        print("Mock: Deleted all messages in chat \(chatId)")
    }

    func deleteChat(chatId: String) async throws {
        await simulateDelay()
        print("Mock: Deleted chat \(chatId) and all its messages")
    }

    func deleteAllUserChats(userId: String) async throws {
        await simulateDelay()
        let userChats = chats.filter { $0.userId == userId }
        print("Mock: Deleted \(userChats.count) chats for user \(userId)")
    }

    func reportChat(chatId: String, userId: String) async throws {
        await simulateDelay()
        print("Mock: Reported chat \(chatId) by user \(userId)")
    }

    func observeChatMessages(chatId: String, onUpdate: @escaping ([ChatMessageModal]) -> Void) -> ListenerRegistration {
        // Mock implementation - immediately return mock messages
        let messages = ChatMessageModal.mocks.filter { $0.chatId == chatId }
        onUpdate(messages)

        // Return a mock listener that does nothing
        return MockListenerRegistration()
    }
}

// Mock listener registration for testing
class MockListenerRegistration: NSObject, ListenerRegistration {
    func remove() {
        print("Mock: Removed listener")
    }
}
