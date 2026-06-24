//
//  CreateAccountView.swift
//  AiChat
//
//  Created by Sathya Kumar on 20/06/26.
//

import SwiftUI
import AuthenticationServices

struct CreateAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.authService) private var authservice
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(subtitle)
                .font(.body)
                .foregroundStyle(.primary)

            SignInWithAppleButtonView(
                type: .signIn,
                style: .black,
                cornerRadius: 16
            )
            .frame(height: 55)
            .anyButton(.pressable) {
                onSignInWithApplePressed()
            }

            SignInWithGoogleButtonView(cornerRadius: 16)
                .anyButton(.pressable) {
                    onSignInWithGooglePressed()
                }

            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(uiColor: .systemBackground))
    }

    private func onSignInWithApplePressed() {
        Task {
            do {
               _ = try await authservice.signInApple()
            } catch {
                // Handle error silently or show alert
            }
            dismiss()
        }
    }

    private func onSignInWithGooglePressed() {
        Task {
            do {
               _ = try await authservice.signInGoogle()
            } catch {
                // Handle error silently or show alert
            }
            dismiss()
        }
    }
}

#Preview {
    CreateAccountView(
        title: "Create Account?",
        subtitle: "Don't lose your data! Connect to an SSO provider to save your account."
    )
}
