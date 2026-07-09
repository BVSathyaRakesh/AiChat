//
//  UserRepositoryProtocol.swift
//  AiChat
//
//  Created by Sathya Kumar on 09/07/26.
//

protocol UserRepositoryProtocol {
    var currentUser: UserModel? { get }
    func observeCurrentUser() -> AsyncStream<UserModel?>
}
