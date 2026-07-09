//
//  FetchUserAvatarsUseCase.swift
//  AiChat
//
//  Created by Sathya Kumar on 09/07/26.
//
import SwiftUI

protocol FetchUserAvatarsUseCase {
    func execute(userId: String) async throws -> [AvatarModal]
}

final class RemoteFetchUserAvatarsUseCase: FetchUserAvatarsUseCase {
    
    // MARK: - Dependencies
    private let avatarRepository: AvatarRepositoryProtocol
    
    // MARK: - Initialization
    init(avatarRepository: AvatarRepositoryProtocol) {
        self.avatarRepository = avatarRepository
    }
    
    // MARK: - Use Case Execution
    func execute(userId: String) async throws -> [AvatarModal] {
        // Business rule: User ID must not be empty
        guard !userId.isEmpty else {
            throw ValidationError.emptyUserId
        }
        
        // Fetch avatars from repository
        let avatars = try await avatarRepository.fetchUserAvatarsForAuthor(userId: userId)
        
        // Business rule: Sort avatars by creation date (newest first)
        let sortedAvatars = avatars.sorted { avatar1, avatar2 in
            guard let date1 = avatar1.dateCreated,
                  let date2 = avatar2.dateCreated else {
                return false
            }
            return date1 > date2
        }
        
        return sortedAvatars
    }

    // MARK: - Errors
    enum ValidationError: LocalizedError {
        case emptyUserId
        case custom(String)
        
        var errorDescription: String? {
            switch self {
            case .emptyUserId:
                return "User ID cannot be empty"
            case .custom(_):
               return ""
            }
        }
    }
}
