//
//  TextValidationHelper.swift
//  AiChat
//
//  Created by Sathya Kumar on 22/06/26.
//
import Foundation
struct TextValidationHelper {
    enum ValidationError: LocalizedError {
        case textTooShort(min: Int)
        case hasBadWords
        var errorDescription: String? {
            switch self {
            case .textTooShort(min: let min):
                return "Please enter minimum \(min) charceters"
            case .hasBadWords:
                return "Bad words detected. Please rephrase your message"
            }
        }
    }
    
    static func validateTextField(text: String) throws {
        let minimumCharecterCount = 3
        let badWords = ["shit", "bitch", "ass"]
        
        guard text.count > minimumCharecterCount else {
            throw ValidationError.textTooShort(min: minimumCharecterCount)
        }
        
        guard !text.containsAny(of: badWords) else {
            throw ValidationError.hasBadWords
        }
    }
    
}
