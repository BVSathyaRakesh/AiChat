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

    func generateText(input: String) async throws -> String {
        // Simple text generation without context
        return try await generateTextWithContext(
            messages: [.user(input)],
            systemPrompt: nil
        )
    }

    func generateTextWithContext(messages: [AIChatModel], systemPrompt: String?) async throws -> String {
        // Pollinations.ai text generation with context - completely free, no API key needed
        guard let url = URL(string: Constants.AIConstants.pollinationsTextAPIURL) else {
            throw NSError(domain: "PollinationsAIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var allMessages = messages

        // Add system prompt if provided
        if let systemPrompt = systemPrompt {
            allMessages.insert(.system(systemPrompt), at: 0)
        }

        let requestBody: [String: Any] = [
            "messages": allMessages.map { $0.toAPIFormat() },
            "model": "openai",
            "jsonMode": false
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "PollinationsAIService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to generate text"])
        }

        guard let text = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "PollinationsAIService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
        }

        return cleanPollinationsAds(from: text)
    }

    private func cleanPollinationsAds(from text: String) -> String {
        var cleanedText = text

        // Remove common Pollinations ad patterns
        let adPatterns = [
            // Support message with dashes
            #"---\s*\*\*Support Pollinations\.AI:\*\*\s*---"#,
            // Ad marker with emojis
            #"\*\*Ad\*\*\s*🌸"#,
            #"🌸\s*\*\*Ad\*\*\s*🌸"#,
            // Powered by message with links
            #"Powered by Pollinations\.AI.*?accessible for everyone\."#,
            #"\[Support our mission\]\(https?://pollinations\.ai/redirect/[^\)]+\)"#,
            // Generic pollinations promotion
            #"Support Pollinations\.AI"#,
            #"pollinations\.ai/redirect/[^\s\)]*"#
        ]

        for pattern in adPatterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .dotMatchesLineSeparators]) {
                let range = NSRange(cleanedText.startIndex..., in: cleanedText)
                cleanedText = regex.stringByReplacingMatches(in: cleanedText, options: [], range: range, withTemplate: "")
            }
        }

        // Remove multiple consecutive newlines and trim
        cleanedText = cleanedText.replacingOccurrences(of: #"\n{3,}"#, with: "\n\n", options: .regularExpression)
        cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)

        return cleanedText
    }
}
