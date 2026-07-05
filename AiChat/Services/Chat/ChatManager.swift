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
}

struct FirebaseChatMessageService: ChatService {
    
    var collection: CollectionReference {
        Firestore.firestore().collection("chats")
    }

    func createNewChat(chat: ChatModal) async throws {
        try collection.document(chat.id).setData(from: chat, merge: true)
    }
    
}

struct MockChatMessageService: ChatService {
    func createNewChat(chat: ChatModal) async throws {
        
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
    
}
