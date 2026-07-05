//
//  AIChatModel.swift
//  AiChat
//
//  Created by Sathya Kumar on 04/07/26.
//

import Foundation

enum AIChatRole: String, Codable {
    case system
    case user
    case assistant
}

struct AIChatModel: Codable, Hashable {
    let role: AIChatRole
    let message: String

    // Convenience initializers
    static func system(_ content: String) -> AIChatModel {
        AIChatModel(role: .system, message: content)
    }

    static func user(_ content: String) -> AIChatModel {
        AIChatModel(role: .user, message: content)
    }

    static func assistant(_ content: String) -> AIChatModel {
        AIChatModel(role: .assistant, message: content)
    }

    // Convert to API format for Pollinations
    func toAPIFormat() -> [String: String] {
        return [
            "role": role.rawValue,
            "message": message
        ]
    }
}
