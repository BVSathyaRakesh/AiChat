//
//  ChatManager.swift
//  AiChat
//
//  Created by Sathya Kumar on 05/07/26.
//
import SwiftUI
import FirebaseFirestore

protocol ChatService {
    func createNewChat(chat: ChatModal) async throws
    func addChatMessage(chatId: String, message: ChatMessageModal) async throws
}

struct FirebaseChatMessageService: ChatService {
    
    var collection: CollectionReference {
        Firestore.firestore().collection("chats")
    }
    
    private func messageCollections(chatId: String) -> CollectionReference {
        collection.document(chatId).collection("messages")
    }

    func createNewChat(chat: ChatModal) async throws {
        try collection.document(chat.id).setData(from: chat, merge: true)
    }
    
    func addChatMessage(chatId: String, message: ChatMessageModal) async throws {
        // Add the message to the chat sub-collection
        try messageCollections(chatId: chatId).document(message.id).setData(from: message, merge: true)
        // Update the datemodified
        try await collection.document(chatId).updateData([
            ChatModal.CodingKeys.dateModified.rawValue: Date.now
        ])
    }
    
}

struct MockChatMessageService: ChatService {
    func createNewChat(chat: ChatModal) async throws {
        
    }
    func addChatMessage(chatId: String, message: ChatMessageModal) async throws {
        
    }
}

@Observable
class ChatManager {
    
    private let chatService: ChatService
    
    init(chatService: ChatService) {
        self.chatService = chatService
    }
    
    func createNewChat(chat: ChatModal) async throws {
        try await chatService.createNewChat(chat: chat)
    }
    
    func addChatMessage(chatId: String, message: ChatMessageModal) async throws {
        try await chatService.addChatMessage(chatId: chatId, message: message)
    }
    
}
