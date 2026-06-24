//
//  FirebaseAuthService.swift
//  AiChat
//
//  Created by Sathya Kumar on 23/06/26.
//

import FirebaseAuth
import SwiftUI
import SignInAppleAsync

struct FirebaseAuthService: AuthService {
    
    func getAuthenticatedUser() -> UserAuthInfo? {
        if let user = Auth.auth().currentUser {
            return UserAuthInfo(user: user)
        }
        return nil
    }
    
    func addAuthenticatedUserListener(onListenerAttached: (any NSObjectProtocol) -> Void) -> AsyncStream<UserAuthInfo?> {
        AsyncStream { continuation in
            let listener = Auth.auth().addStateDidChangeListener { _, currentUser in
                if let currentUser {
                    let user = UserAuthInfo(user: currentUser)
                    continuation.yield(user)
                } else {
                    continuation.yield(nil)
                }
            }
            onListenerAttached(listener)
        }
    }

    func getAuthenticatedUserRefreshed() async throws -> UserAuthInfo? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        try await user.reload()
        guard let refreshedUser = Auth.auth().currentUser else {
            return nil
        }
        return UserAuthInfo(user: refreshedUser)
    }

    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewuser: Bool) {
        let result = try await Auth.auth().signInAnonymously()
        return result.asAuthInfo
    }
    
    func signInApple() async throws -> (user: UserAuthInfo, isNewuser: Bool) {
        let helper = SignInWithAppleHelper()
        let response = try await helper.signIn()
        let credential = OAuthProvider.credential(
            providerID: AuthProviderID.apple,
            idToken: response.token,
            rawNonce: response.nonce
        )
        return try await signInWithCredential(credential)
    }

    func signInGoogle() async throws -> (user: UserAuthInfo, isNewuser: Bool) {
        let helper = SignInWithGoogleHelper()
        let response = try await helper.signIn()
        let credential = GoogleAuthProvider.credential(
            withIDToken: response.idToken,
            accessToken: response.accessToken
        )
        return try await signInWithCredential(credential)
    }
    
    private func signInWithCredential(_ credential: AuthCredential) async throws -> (user: UserAuthInfo, isNewuser: Bool) {
        if let user = Auth.auth().currentUser, user.isAnonymous {
            do {
                let result = try await user.link(with: credential)
                try await result.user.reload()
                let refreshedUser = Auth.auth().currentUser!
                return (UserAuthInfo(user: refreshedUser), result.additionalUserInfo?.isNewUser ?? false)
            } catch {
                let nsError = error as NSError
                if nsError.code == 17025 {
                    if let secondaryCredential = nsError.userInfo["FIRAuthErrorUserInfoUpdatedCredentialKey"] as? AuthCredential {
                        let result = try await Auth.auth().signIn(with: secondaryCredential)
                        return result.asAuthInfo
                    }
                }
                throw error
            }
        }

        let result = try await Auth.auth().signIn(with: credential)
        return result.asAuthInfo
    }

    func signout() throws {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        try await user.delete()
    }
 
}

extension AuthDataResult {
    var asAuthInfo: (user: UserAuthInfo, isNewuser: Bool) {
        let user = UserAuthInfo(user: user)
        let isNewuser = additionalUserInfo?.isNewUser ?? true
        return (user, isNewuser)
    }
}

enum AuthError: LocalizedError {
    case userNotFound
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "Currenthenticated User Not Found"
        }
    }
}
