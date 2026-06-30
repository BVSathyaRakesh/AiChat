//
//  PollinationsAIService.swift
//  AiChat
//
//  Created by Sathya Kumar on 30/06/26.
//

import SwiftUI

struct PollinationsAIService: AIService {
    func generateImage(input: String) async throws -> String {
        // Pollinations.ai - completely free, no API key needed
        return Constants.AI.pollinationsImageURL(prompt: input)
    }
}
