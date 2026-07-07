//
//  FirebaseChatMessageService.swift
//  AiChat
//
//  Created by Sathya Kumar on 07/07/26.
//

import SwiftUI
import FirebaseFirestore


struct FirebaseChatMessageService: ChatService {

    var collection: CollectionReference {
        Firestore.firestore().collection("chats")
    }

    var reportCollection: CollectionReference {
        Firestore.firestore().collection("chat_reports")
    }

    private func messageCollections(chatId: String) -> CollectionReference {
        collection.document(chatId).collection("messages")
    }

    func createNewChat(chat: ChatModal) async throws {
        try collection.document(chat.id).setData(from: chat, merge: true)
    }

    func getChat(chatId: String) async throws -> ChatModal? {
        let document = try await collection.document(chatId).getDocument()
        return try? document.data(as: ChatModal.self)
    }

    func getUserChats(userId: String) async throws -> [ChatModal] {
        let snapshot = try await collection
            .whereField(ChatModal.CodingKeys.userId.rawValue, isEqualTo: userId)
            .getDocuments()

        return try snapshot.decode(as: ChatModal.self)
    }

    func getChatMessages(chatId: String) async throws -> [ChatMessageModal] {
        let snapshot = try await messageCollections(chatId: chatId)
            .order(by: ChatMessageModal.CodingKeys.dateCreated.rawValue, descending: false)
            .getDocuments()

        return try snapshot.documents.compactMap { doc in
            try doc.data(as: ChatMessageModal.self)
        }
    }

    func getLastMessage(chatId: String) async throws -> ChatMessageModal? {
        let snapshot = try await messageCollections(chatId: chatId)
            .order(by: ChatMessageModal.CodingKeys.dateCreated.rawValue, descending: true)
            .limit(to: 1)
            .getDocuments()

        return try snapshot.documents.first?.data(as: ChatMessageModal.self)
    }

    func addChatMessage(chatId: String, message: ChatMessageModal) async throws {
        // Add the message to the chat sub-collection
        try messageCollections(chatId: chatId).document(message.id).setData(from: message, merge: true)
        // Update the datemodified
        try await collection.document(chatId).updateData([
            ChatModal.CodingKeys.dateModified.rawValue: Date.now
        ])
    }

    func reportChat(chatId: String, userId: String) async throws {
        let report = ChatReportModel.create(chatId: chatId, userId: userId)
        try reportCollection.document(report.id).setData(from: report)
    }

    func observeChatMessages(chatId: String, onUpdate: @escaping ([ChatMessageModal]) -> Void) -> ListenerRegistration {
        return messageCollections(chatId: chatId)
            .order(by: ChatMessageModal.CodingKeys.dateCreated.rawValue, descending: false)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("Error listening to messages: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let messages = snapshot.documents.compactMap { doc -> ChatMessageModal? in
                    try? doc.data(as: ChatMessageModal.self)
                }

                onUpdate(messages)
            }
    }
    
    func deleteChatMessages(chatId: String) async throws {
        // Get all messages in the subcollection
        let messagesSnapshot = try await messageCollections(chatId: chatId).getDocuments()

        // Use batch to delete all messages
        let batch = Firestore.firestore().batch()

        for document in messagesSnapshot.documents {
            batch.deleteDocument(document.reference)
        }

        // Commit the batch
        try await batch.commit()
    }

    func deleteChat(chatId: String) async throws {
        // Delete all messages first
        try await deleteChatMessages(chatId: chatId)

        // Then delete the chat document
        try await collection.document(chatId).delete()
    }

    func deleteAllUserChats(userId: String) async throws {
        // Get all chats for this user
        let chatsSnapshot = try await collection
            .whereField(ChatModal.CodingKeys.userId.rawValue, isEqualTo: userId)
            .getDocuments()

        // Reuse deleteChat logic for each chat
        for chatDoc in chatsSnapshot.documents {
            try await deleteChat(chatId: chatDoc.documentID)
        }
    }

}
