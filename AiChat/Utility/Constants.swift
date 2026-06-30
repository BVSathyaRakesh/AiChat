//
//  Constants.swift
//  AiChat
//
//  Created by Sathya Kumar on 16/06/26.
//

import Foundation

struct Constants {
    static var randomImage = "https://picsum.photos/600/600"
    static var privacyPolicyURL = "https://www.apple.com/"
    static var termsOfServiceURL = "https://www.apple.com/"

    // AI Image Generation
    struct AI {
        static let pollinationsBaseURL = "https://image.pollinations.ai/prompt/"
        static let defaultImageWidth = 512
        static let defaultImageHeight = 512

        static func pollinationsImageURL(prompt: String, width: Int = defaultImageWidth, height: Int = defaultImageHeight, noLogo: Bool = true) -> String {
            let encodedPrompt = prompt.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? prompt
            return "\(pollinationsBaseURL)\(encodedPrompt)?width=\(width)&height=\(height)&nologo=\(noLogo)"
        }
    }
}
