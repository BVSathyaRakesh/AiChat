//
//  AIService.swift
//  AiChat
//
//  Created by Sathya Kumar on 30/06/26.
//

protocol AIService {
    func generateImage(input: String) async throws -> String
}
