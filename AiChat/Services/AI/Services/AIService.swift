//
//  AIService.swift
//  AiChat
//
//  Created by Sathya Kumar on 30/06/26.
//

import Foundation

protocol AIService {
    func generateImage(input: String) async throws -> String
    func generateText(input: String) async throws -> String
    func generateTextWithContext(messages: [AIChatModel], systemPrompt: String?) async throws -> String
}
