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
    let content: String

    // Convenience initializers
    static func system(_ content: String) -> AIChatModel {
        AIChatModel(role: .system, content: content)
    }

    static func user(_ content: String) -> AIChatModel {
        AIChatModel(role: .user, content: content)
    }

    static func assistant(_ content: String) -> AIChatModel {
        AIChatModel(role: .assistant, content: content)
    }

    // Convert to API format for Pollinations
    func toAPIFormat() -> [String: String] {
        return [
            "role": role.rawValue,
            "content": content
        ]
    }
}
