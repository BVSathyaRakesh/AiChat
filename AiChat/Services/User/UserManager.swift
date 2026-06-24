//
//  UserManager.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//

import SwiftUI
import SwiftfulUtilities


@MainActor
@Observable
class UserManager {
    
    private let userService: UserService
    private(set) var currentuser: UserModel?
 
    init(userService: UserService) {
        self.userService = userService
        self.currentuser = nil
    }
    
    func login(auth: UserAuthInfo, isNewUser: Bool) async throws {
        let creationVersion = isNewUser ? Utilities.appVersion : nil
        let user = UserModel(auth: auth, createionVersion: creationVersion)
        try await userService.saveUser(user: user)
    }
    
}
