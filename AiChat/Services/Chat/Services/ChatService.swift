//
//  ChatService.swift
//  AiChat
//
//  Created by Sathya Kumar on 07/07/26.
//

import Foundation
import FirebaseFirestore

protocol ChatService {
    func createNewChat(chat: ChatModal) async throws
    func getChat(chatId: String) async throws -> ChatModal?
    func getUserChats(userId: String) async throws -> [ChatModal]
    func getChatMessages(chatId: String) async throws -> [ChatMessageModal]
    func getLastMessage(chatId: String) async throws -> ChatMessageModal?
    func addChatMessage(chatId: String, message: ChatMessageModal) async throws
    func deleteChatMessages(chatId: String) async throws
    func deleteChat(chatId: String) async throws
    func deleteAllUserChats(userId: String) async throws
    func reportChat(chatId: String, userId: String) async throws
    func observeChatMessages(chatId: String, onUpdate: @escaping ([ChatMessageModal]) -> Void) -> ListenerRegistration
}
