//
//  EmptyStateView.swift
//  AiChat
//
//  Created by Sathya Kumar on 03/07/26.
//

import SwiftUI

struct EmptyStateView: View {
    let emoji: String?
    let title: String
    let message: String
    let buttonTitle: String?
    let action: (() -> Void)?

    init(
        emoji: String? = nil,
        title: String,
        message: String,
        buttonTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.emoji = emoji
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: 16) {
            if let emoji {
                Text(emoji)
                    .font(.system(size: 60))
                    .padding(.bottom, 8)
            }

            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if let buttonTitle, let action {
                Button(action: action) {
                    Text(buttonTitle)
                        .font(.body)
                }
                .padding(.top, 8)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}

#Preview("Error State") {
    EmptyStateView(
        title: "Error",
        message: "Please check your internet connection\nand try again.",
        buttonTitle: "Try again"
    ) {
        print("Retry tapped")
    }
}

#Preview("Empty State with Emoji") {
    EmptyStateView(
        emoji: "🤖",
        title: "No Avatars Found",
        message: "There are no avatars in this category yet."
    )
}

#Preview("Empty State without Emoji") {
    EmptyStateView(
        title: "No Avatars",
        message: "There are no avatars available."
    )
}
