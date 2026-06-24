//
//  MockAuthService.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//

import SwiftUI
struct MockAuthService: AuthService {
    
    let currentUser: UserAuthInfo?
    
    init(user: UserAuthInfo? = nil) {
        self.currentUser = user
    }
    
    func getAuthenticatedUser() -> UserAuthInfo? {
        currentUser
    }
    
    func getAuthenticatedUserRefreshed() async throws -> UserAuthInfo? {
        currentUser
    }
    
    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewuser: Bool) {
        let user = UserAuthInfo.mock(isAnonymous: true)
        return (user, true)
    }
    
    func signInApple() async throws -> (user: UserAuthInfo, isNewuser: Bool) {
        let user = UserAuthInfo.mock(isAnonymous: false)
        return (user, false)
    }
    
    func signInGoogle() async throws -> (user: UserAuthInfo, isNewuser: Bool) {
        let user = UserAuthInfo.mock(isAnonymous: false)
        return (user, false)
    }
        
    func signout() throws {
        
    }
    
    func deleteAccount() async throws {
        
    }
    
}
