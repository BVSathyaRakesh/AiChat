//
//  AIManager.swift
//  AiChat
//
//  Created by Sathya Kumar on 30/06/26.
//
import SwiftUI

@Observable
class AIManager: AIService {

    private let aiService: AIService

    init(aiService: AIService) {
        self.aiService = aiService
    }

    func generateImage(input: String) async throws -> String {
        return try await aiService.generateImage(input: input)
    }

}
