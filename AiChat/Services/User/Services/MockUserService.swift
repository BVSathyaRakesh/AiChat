//
//  MockUserService.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//

import SwiftUI

struct MockUserService: UserService {

    let currentUser: UserModel?

    init(user: UserModel? = nil) {
        self.currentUser = user
    }

    func saveUser(user: UserModel) async throws {
        // Mock: do nothing
    }

    func addUserListener(userId: String, onListenerAttached: (AnyObject) -> Void) -> AsyncStream<UserModel?> {
        AsyncStream { continuation in
            let mockListener = NSObject()
            onListenerAttached(mockListener)
            continuation.yield(currentUser ?? UserModel.mock)
        }
    }

    func deleteUser(userId: String) async throws {
        // Mock: do nothing
    }

    func updateOnboardingComplete(userId: String, profileColorHex: String) async throws {
        // Mock: do nothing
    }

}
