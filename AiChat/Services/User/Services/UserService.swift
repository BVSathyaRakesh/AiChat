//
//  UserService.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//

import Foundation

protocol UserService {
    func saveUser(user: UserModel) async throws
    func addUserListener(userId: String, onListenerAttached: (AnyObject) -> Void) -> AsyncStream<UserModel?>
    func deleteUser(userId: String) async throws
    func updateOnboardingComplete(userId: String, profileColorHex: String) async throws
}

enum UserServiceError: LocalizedError {
    case userNotFound
    case saveFailed
    case deleteFailed

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found"
        case .saveFailed:
            return "Failed to save user"
        case .deleteFailed:
            return "Failed to delete user"
        }
    }
}
