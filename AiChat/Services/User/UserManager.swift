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
class UserManager: UserServices {
    
    internal let local: LocalUserPersistance
    internal let remote: RemoteUserService
    private(set) var currentuser: UserModel?
    private var listener: AnyObject?

    init(services: UserServices) {
        self.remote = services.remote
        self.local = services.local
        self.currentuser = local.getCurrentUser()
    }

    func login(auth: UserAuthInfo, isNewUser: Bool) async throws {
        let creationVersion = isNewUser ? Utilities.appVersion : nil
        let user = UserModel(auth: auth, createionVersion: creationVersion)
        try await remote.saveUser(user: user)
        startListening(userId: auth.uid)
    }
    
    private func saveUserLocally(user: UserModel) {
        do {
           try local.saveUser(user: user)
        } catch {
            print("Failed to save user locall: \(error)")
        }
    }
    
    func deleteUser(userId: String) async throws {
        try await remote.deleteUser(userId: userId)
    }

    func completeOnboarding(profileColorHex: String) async throws {
        guard let userId = currentuser?.userId else {
            throw UserServiceError.userNotFound
        }
        try await remote.updateOnboardingComplete(userId: userId, profileColorHex: profileColorHex)
    }

    func logout() {
        stopListening()
    }

    private func startListening(userId: String) {
        Task {
            for await user in remote.addUserListener(userId: userId, onListenerAttached: { listener in
                self.listener = listener
            }) {
                self.currentuser = user
                if let user = user {
                    saveUserLocally(user: user)
                }
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
