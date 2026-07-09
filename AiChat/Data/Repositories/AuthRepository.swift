//
//  DefaultAuthRepository.swift
//  AiChat
//
//  Created by Sathya Kumar on 09/07/26.
//

import Foundation

 /// Repository implementation for Authentication operations
 /// Acts as an adapter between Domain layer and AuthManager
 final class AuthRepository: AuthRepositoryProtocol {

     // MARK: - Dependencies
     private let authManager: AuthManager

     // MARK: - Initialization
     init(authManager: AuthManager) {
         self.authManager = authManager
     }

     // MARK: - AuthRepositoryProtocol Implementation
     func getAuthId() throws -> String {
         // Delegate to existing manager
         return try authManager.getAuthId()
     }

     var isAuthenticated: Bool {
         // Check if we can get an auth ID without throwing
         do {
             _ = try authManager.getAuthId()
             return true
         } catch {
             return false
         }
     }
 }
