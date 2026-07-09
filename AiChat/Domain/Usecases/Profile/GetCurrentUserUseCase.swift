//
//  GetCurrentUserUseCase.swift
//  AiChat
//
//  Created by Sathya Kumar on 09/07/26.
//
import SwiftUI

/// Protocol defining the contract for getting current user data
protocol GetCurrentUserUseCase {
    /// Gets the current user and their authenticated ID
    func execute() async throws -> UserModel

    /// Gets just the authenticated user ID
    func getUserId() throws -> String
}

/// Default implementation of GetCurrentUserUseCase
/// Business logic: Combine user data with authentication state
final class DefaultGetCurrentUserUseCase: GetCurrentUserUseCase {

    // MARK: - Dependencies
    private let userRepository: UserRepositoryProtocol
    private let authRepository: AuthRepositoryProtocol

    // MARK: - Initialization
    init(
        userRepository: UserRepositoryProtocol,
        authRepository: AuthRepositoryProtocol
    ) {
        self.userRepository = userRepository
        self.authRepository = authRepository
    }

    // MARK: - Use Case Execution
    func execute() async throws -> UserModel {
        // Business rule: Must be authenticated
        guard authRepository.isAuthenticated else {
            throw AuthError.notAuthenticated
        }

        // Get current user from repository
        guard let user = userRepository.currentUser else {
            throw UserError.userNotFound
        }

        return user
    }

    func getUserId() throws -> String {
        return try authRepository.getAuthId()
    }
    
    // MARK: - Errors
    enum AuthError: LocalizedError {
        case notAuthenticated

        var errorDescription: String? {
            switch self {
            case .notAuthenticated:
                return "User is not authenticated"
            }
        }
    }
}

enum UserError: LocalizedError {
    case userNotFound

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User data not found"
        }
    }
}
