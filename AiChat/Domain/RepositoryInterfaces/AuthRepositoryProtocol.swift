//
//  AuthRepositoryProtocol.swift
//  AiChat
//
//  Created by Sathya Kumar on 09/07/26.
//

protocol AuthRepositoryProtocol {
    /// Gets the authenticated user ID
    /// Throws an error if no user is authenticated
    func getAuthId() throws -> String
    /// Checks if a user is currently authenticated
    var isAuthenticated: Bool { get }
}
