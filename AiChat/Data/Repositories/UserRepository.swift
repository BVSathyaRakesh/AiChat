//
//  DefaultUserRepository.swift
//  AiChat
//
//  Created by Sathya Kumar on 09/07/26.
//
import SwiftUI

/// Repository implementation for User data access
 /// Acts as an adapter between Domain layer and UserManager
 final class UserRepository: UserRepositoryProtocol {

     // MARK: - Dependencies
     private let userManager: UserManager

     // MARK: - Initialization
     init(userManager: UserManager) {
         self.userManager = userManager
     }

     // MARK: - UserRepositoryProtocol Implementation

     var currentUser: UserModel? {
         // Delegate to existing manager
         return userManager.currentuser
     }

     func observeCurrentUser() -> AsyncStream<UserModel?> {
         // Create async stream that observes user changes
         AsyncStream { continuation in
             // Initial value
             continuation.yield(userManager.currentuser)

             // Note: If UserManager has real-time listener,
             // you would subscribe to it here
             // For now, just return initial value

             continuation.onTermination = { _ in
                 // Cleanup if needed
             }
         }
     }
 }
