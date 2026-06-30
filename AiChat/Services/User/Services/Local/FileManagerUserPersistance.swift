//
//  FileManagerUserPersistance.swift
//  AiChat
//
//  Created by Sathya Kumar on 30/06/26.
//
import Foundation

struct FileManagerUserPersistance: LocalUserPersistance {
    
    private let documentKey = "user-data"
    
    func getCurrentUser() -> UserModel? {
        try? FileManager.default.getDocument(key: documentKey)
    }
    
    func saveUser(user: UserModel) throws {
        try FileManager.default.saveDocument(key: documentKey, value: user)
    }
}
