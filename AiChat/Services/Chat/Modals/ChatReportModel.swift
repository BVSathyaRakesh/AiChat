//
//  ChatReportModel.swift
//  AiChat
//
//  Created by Sathya Kumar on 07/07/26.
//

import Foundation

struct ChatReportModel: Codable, Identifiable, Hashable {
    let id: String
    let chatId: String
    let userId: String // reporting user
    let isActive: Bool
    let dateCreated: Date

    enum CodingKeys: String, CodingKey {
        case id
        case chatId = "chat_id"
        case userId = "user_id"
        case isActive = "is_active"
        case dateCreated = "date_created"
    }

    static func create(chatId: String, userId: String) -> ChatReportModel {
        ChatReportModel(
            id: UUID().uuidString,
            chatId: chatId,
            userId: userId,
            isActive: true,
            dateCreated: Date()
        )
    }
}
