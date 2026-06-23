//
//  FirebaseAuthService.swift
//  AiChat
//
//  Created by Sathya Kumar on 23/06/26.
//

import FirebaseAuth
import SwiftUI

extension EnvironmentValues {
    @Entry var authService: FirebaseAuthService = FirebaseAuthService()
}

struct UserAuthInfo: Sendable {
    let uid: String
    let email: String?
    let isAonymous: Bool?
    let creationDate: Date?
    let lastSignInDate: Date?
    
    init(
        uid: String,
        email: String? = nil,
        isAonymous: Bool? = false,
        creationDate: Date? = nil,
        lastSignInDate: Date? = nil
    ) {
        self.uid = uid
        self.email = email
        self.isAonymous = isAonymous
        self.creationDate = creationDate
        self.lastSignInDate = lastSignInDate
    }
    
    init(user: User){
        self.uid = user.uid
        self.email = user.email
        self.isAonymous = user.isAnonymous
        self.creationDate = user.metadata.creationDate
        self.lastSignInDate = user.metadata.lastSignInDate
    }
}

struct FirebaseAuthService {
    
    func getAuthenticatedUser() -> UserAuthInfo? {
        if let user = Auth.auth().currentUser{
            return UserAuthInfo(user: user)
        }
        return nil
    }
    
    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewuser: Bool) {
        let result = try await Auth.auth().signInAnonymously()
        let user = UserAuthInfo(user: result.user)
        let isNewuser = result.additionalUserInfo?.isNewUser ?? true
        return (user, isNewuser)
    }
}
