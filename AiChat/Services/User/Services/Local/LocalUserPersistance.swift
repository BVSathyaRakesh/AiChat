//
//  LocalUserPersistence.swift
//  AiChat
//
//  Created by Sathya Kumar on 25/06/26.
//

import SwiftUI

protocol LocalUserPersistence {
    func getCurrentUser() -> UserModel?
    func saveUser(user: UserModel) throws
}
