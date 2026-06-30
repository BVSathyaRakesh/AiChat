//
//  MockAIService.swift
//  AiChat
//
//  Created by Sathya Kumar on 30/06/26.
//

import Foundation

struct MockAIService: AIService {

    func generateImage(input: String) async throws -> String {
        try await Task.sleep(for: .seconds(2))
        return Constants.randomImage
    }

}