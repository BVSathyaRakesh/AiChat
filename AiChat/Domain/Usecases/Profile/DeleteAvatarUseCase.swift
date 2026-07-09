//
//  DeleteAvatarUseCase.swift
//  AiChat
//
//  Created by Sathya Kumar on 09/07/26.
//

import SwiftUI

/// Protocol defining the contract for deleting avatars

protocol DeleteAvatarUseCase {
     func execute(avatarId: String) async throws
 }

/// Default implementation of DeleteAvatarUseCase
/// Business logic: Delete an avatar and handle related cleanup
final class DefaultDeleteAvatarUseCase: DeleteAvatarUseCase {
   
   // MARK: - Dependencies
   private let avatarRepository: AvatarRepositoryProtocol
   
   // MARK: - Initialization
   init(avatarRepository: AvatarRepositoryProtocol) {
       self.avatarRepository = avatarRepository
   }
   
   // MARK: - Use Case Execution
   func execute(avatarId: String) async throws {
       // Business rule: Avatar ID must not be empty
       guard !avatarId.isEmpty else {
           throw ValidationError.emptyAvatarId
       }
       
       // Delete avatar from repository
       try await avatarRepository.deleteAvatar(avatarId: avatarId)
       
       // Future: Could add analytics tracking here
       // Future: Could add cleanup of related chat messages
   }
   
   // MARK: - Errors
   enum ValidationError: LocalizedError, Equatable {
       static let emptyAvatarId = ValidationError.custom("Avatar ID cannot be empty")
       
       case emptyUserId
       case custom(String)
       
       var errorDescription: String? {
           switch self {
           case .emptyUserId:
               return "User ID cannot be empty"
           case .emptyAvatarId:
               return "Avatar ID cannot be empty"
           case .custom(let message):
               return message
           }
       }
   }
}
