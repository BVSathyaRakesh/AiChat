//
//  UserService.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//

import Foundation

protocol UserServices {
    var remote: RemoteUserService { get }
    var local: LocalUserPersistence { get }
}

struct ProductionUserServices: UserServices {
    var remote: RemoteUserService
    var local: LocalUserPersistence
    
    init(userModal: UserModel? = nil) {
        self.remote = FirebaseUserService()
        self.local  = FileManagerUserPersistence()
    }
}

struct MockUserServices: UserServices {
    var remote: RemoteUserService
    var local: LocalUserPersistence
    
    init(userModal: UserModel? = nil) {
        self.local = MockLoclUserPersistence(user: userModal)
        self.remote = MockUserService(user: userModal)
    }
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
