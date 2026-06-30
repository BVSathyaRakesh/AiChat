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
        case textTooLong(max: Int)
        case hasBadWords

        var errorDescription: String? {
            switch self {
            case .textTooShort(min: let min):
                return "Please enter at least \(min) characters"
            case .textTooLong(max: let max):
                return "Maximum \(max) characters allowed"
            case .hasBadWords:
                return "Inappropriate language detected. Please rephrase."
            }
        }
    }

    static func validateTextField(text: String, minLength: Int = 3, maxLength: Int = 30) throws {
        let badWords = ["shit", "bitch", "ass"]

        // Trim whitespace
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            throw ValidationError.textTooShort(min: minLength)
        }

        guard trimmedText.count > minLength else {
            throw ValidationError.textTooShort(min: minLength)
        }

        guard trimmedText.count <= maxLength else {
            throw ValidationError.textTooLong(max: maxLength)
        }

        guard !text.containsAny(of: badWords) else {
            throw ValidationError.hasBadWords
        }
    }

}
