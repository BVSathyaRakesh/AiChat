//
//  RemoteUserService.swift
//  AiChat
//
//  Created by Sathya Kumar on 30/06/26.
//

protocol RemoteUserService {
    func saveUser(user: UserModel) async throws
    func addUserListener(userId: String, onListenerAttached: (AnyObject) -> Void) -> AsyncStream<UserModel?>
    func deleteUser(userId: String) async throws
    func updateOnboardingComplete(userId: String, profileColorHex: String) async throws
}
