//
//  MockLoclUserPersistence.swift
//  AiChat
//
//  Created by Sathya Kumar on 30/06/26.
//

struct MockLoclUserPersistence: LocalUserPersistence {
    
    let currentUser: UserModel?

    init(user: UserModel? = nil) {
        self.currentUser = user
    }
    
    func getCurrentUser() -> UserModel? {
        currentUser
    }
    
    func saveUser(user: UserModel) throws {
        
    }
}
