//
//  UserService.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//


protocol UserService {
    func saveUser(user: UserModel) async throws
}