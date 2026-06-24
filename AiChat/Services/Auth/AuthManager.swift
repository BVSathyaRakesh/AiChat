//
//  AuthManager.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//

import SwiftUI
@MainActor
@Observable
class AuthManager {
    
    private let authService: AuthService
    private(set) var auth: UserAuthInfo?
    private var listener: (any NSObjectProtocol)?
    
    init(authService: AuthService) {
        self.authService = authService
        self.auth = authService.getAuthenticatedUser()
        addAUthListener()
    }
            
    func getAuthId() throws -> String {
        guard let uid =  auth?.uid else {
            throw AuthError.notSignedIn
        }
        return uid
    }
    
    func addAUthListener() {
        Task {
           for await value in authService.addAuthenticatedUserListener(onListenerAttached: { listener  in
                self.listener = listener
            }) {
                self.auth = value
                print("Auth Listener success: \(value?.uid ?? "no Uid")")
            }
        }
    }
   
    func getAuthenticatedUserRefreshed() async throws -> UserAuthInfo? {
        try await authService.getAuthenticatedUserRefreshed()
    }
    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewuser: Bool) {
        try await authService.signInAnonymously()
    }
    func signInApple() async throws -> (user: UserAuthInfo, isNewuser: Bool) {
        try await authService.signInApple()
    }
    func signInGoogle() async throws -> (user: UserAuthInfo, isNewuser: Bool) {
        try await authService.signInGoogle()
    }
    func signout() throws {
        try authService.signout()
        auth = nil
    }
    func deleteAccount() async throws {
        try await authService.deleteAccount()
    }
    
    enum AuthError: LocalizedError {
        case notSignedIn
    }

}
