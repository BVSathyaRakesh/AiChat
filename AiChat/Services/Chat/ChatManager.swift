//
//  ChatManager.swift
//  AiChat
//
//  Created by Sathya Kumar on 05/07/26.
//
import SwiftUI
import FirebaseFirestore

@Observable
class ChatManager {
    
    private let chatService: ChatService
    
    init(chatService: ChatService) {
        self.chatService = chatService
    }
    
    func createNewChat(chat: ChatModal) async throws {
        try await chatService.createNewChat(chat: chat)
    }

    func getChat(chatId: String) async throws -> ChatModal? {
        return try await chatService.getChat(chatId: chatId)
    }

    func getUserChats(userId: String) async throws -> [ChatModal] {
        return try await chatService.getUserChats(userId: userId)
    }

    func getChatMessages(chatId: String) async throws -> [ChatMessageModal] {
        return try await chatService.getChatMessages(chatId: chatId)
    }

    func getLastMessage(chatId: String) async throws -> ChatMessageModal? {
        return try await chatService.getLastMessage(chatId: chatId)
    }

    func addChatMessage(chatId: String, message: ChatMessageModal) async throws {
        try await chatService.addChatMessage(chatId: chatId, message: message)
    }

    func deleteChatMessages(chatId: String) async throws {
        try await chatService.deleteChatMessages(chatId: chatId)
    }

    func deleteChat(chatId: String) async throws {
        try await chatService.deleteChat(chatId: chatId)
    }

    func deleteAllUserChats(userId: String) async throws {
        try await chatService.deleteAllUserChats(userId: userId)
    }

    func reportChat(chatId: String, userId: String) async throws {
        try await chatService.reportChat(chatId: chatId, userId: userId)
    }

    func observeChatMessages(chatId: String, onUpdate: @escaping ([ChatMessageModal]) -> Void) -> ListenerRegistration {
        return chatService.observeChatMessages(chatId: chatId, onUpdate: onUpdate)
    }

}
