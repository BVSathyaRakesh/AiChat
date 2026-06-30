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
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
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
                // Capture anonymous user ID before sign-in (in case we switch accounts)
                let oldUserId = authManager.auth?.uid
                let wasAnonymous = authManager.auth?.isAnonymous == true

                let result = try await authManager.signInApple()

                // If we switched accounts (old anonymous -> existing account), delete old Firestore doc
                if wasAnonymous, let oldId = oldUserId, oldId != result.user.uid {
                    try? await userManager.deleteUser(userId: oldId)
                }

                // Create/update Firestore document for the current account
                try await userManager.login(auth: result.user, isNewUser: result.isNewuser)
            } catch {
                // Handle error silently or show alert
            }
            dismiss()
        }
    }

    private func onSignInWithGooglePressed() {
        Task {
            do {
                // Capture anonymous user ID before sign-in (in case we switch accounts)
                let oldUserId = authManager.auth?.uid
                let wasAnonymous = authManager.auth?.isAnonymous == true

                let result = try await authManager.signInGoogle()

                // If we switched accounts (old anonymous -> existing account), delete old Firestore doc
                if wasAnonymous, let oldId = oldUserId, oldId != result.user.uid {
                    try? await userManager.deleteUser(userId: oldId)
                }

                // Create/update Firestore document for the current account
                try await userManager.login(auth: result.user, isNewUser: result.isNewuser)
            } catch {
                print("Google Sign-In failure for: \(error)")
                try await Task.sleep(for: .seconds(5))
                onSignInWithGooglePressed()
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
    .environment(AuthManager(authService: MockAuthService()))
    .environment(UserManager(services: MockUserServices(userModal: .mock)))
}
