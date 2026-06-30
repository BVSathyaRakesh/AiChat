//
//  PollinationsAIService.swift
//  AiChat
//
//  Created by Sathya Kumar on 30/06/26.
//

import Foundation

struct PollinationsAIService: AIService {
    func generateImage(input: String) async throws -> String {
        // Pollinations.ai - completely free, no API key needed
        // Returns the URL directly - Pollinations caches the image
        return Constants.AIConstants.pollinationsImageURL(prompt: input)
    }
}
