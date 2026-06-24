//
//  UserManager.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//

import SwiftUI
import SwiftfulUtilities
import FirebaseFirestore

@MainActor
@Observable
class UserManager {

    private let userService: UserService
    private(set) var currentuser: UserModel?
    private var listener: AnyObject?

    init(userService: UserService) {
        self.userService = userService
        self.currentuser = nil
    }

    func login(auth: UserAuthInfo, isNewUser: Bool) async throws {
        let creationVersion = isNewUser ? Utilities.appVersion : nil
        let user = UserModel(auth: auth, createionVersion: creationVersion)
        try await userService.saveUser(user: user)
        startListening(userId: auth.uid)
    }
    
    
    func deleteUser(userId: String) async throws {
        try await userService.deleteUser(userId: userId)
    }

    func completeOnboarding(profileColorHex: String) async throws {
        guard let userId = currentuser?.userId else {
            throw UserServiceError.userNotFound
        }
        try await userService.updateOnboardingComplete(userId: userId, profileColorHex: profileColorHex)
    }

    func logout() {
        stopListening()
    }

    private func startListening(userId: String) {
        Task {
            for await user in userService.addUserListener(userId: userId, onListenerAttached: { listener in
                self.listener = listener
            }) {
                self.currentuser = user
                print("User Listener success: \(user?.userId ?? "no userId")")
            }
        }
    }

    private func stopListening() {
        if let firestoreListener = listener as? FirebaseFirestore.ListenerRegistration {
            firestoreListener.remove()
        }
        listener = nil
        currentuser = nil
    }

}
