//
//  AuthService.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//

import SwiftUI


protocol AuthService {
    func getAuthenticatedUser() -> UserAuthInfo?
    func getAuthenticatedUserRefreshed() async throws -> UserAuthInfo?
    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewuser: Bool)
    func signInApple() async throws -> (user: UserAuthInfo, isNewuser: Bool)
    func signInGoogle() async throws -> (user: UserAuthInfo, isNewuser: Bool)
    func signout() throws
    func deleteAccount() async throws
    func addAuthenticatedUserListener(onListenerAttached: (any NSObjectProtocol) -> Void) -> AsyncStream<UserAuthInfo?>
}
