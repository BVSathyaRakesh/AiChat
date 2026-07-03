//
//  MockAvatarService.swift
//  AiChat
//
//  Created by Sathya Kumar on 02/07/26.
//

import Foundation

struct MockAvatarService: RemoteAvatarService {
    var shouldFail: Bool = false
    var isEmpty: Bool = false
    var delay: CGFloat = 0

    private func simulateDelay() async {
        if delay > 0 {
            try? await Task.sleep(for: .seconds(delay))
        }
    }

    func createAvatar(avatar: AvatarModal) async throws {
        await simulateDelay()
        if shouldFail {
            throw NSError(domain: "Network", code: -1, userInfo: nil)
        }
        print("Mock: Saved avatar \(avatar.name ?? "unnamed")")
    }

    func getAvatarById(avatarId: String) async throws -> AvatarModal {
        await simulateDelay()
        if shouldFail {
            throw NSError(domain: "Network", code: -1, userInfo: nil)
        }
        guard let avatar = AvatarModal.mocks.first(where: { $0.avatarId == avatarId }) else {
            throw NSError(domain: "AvatarService", code: 404, userInfo: nil)
        }
        return avatar
    }

    func fetchUserAvatarsForAuthor(userId: String) async throws -> [AvatarModal] {
        await simulateDelay()
        if shouldFail {
            throw NSError(domain: "Network", code: -1, userInfo: nil)
        }
        return isEmpty ? [] : AvatarModal.mocks
    }

    func fetchFeaturedAvatars(limit: Int) async throws -> [AvatarModal] {
        await simulateDelay()
        if shouldFail {
            throw NSError(domain: "Network", code: -1, userInfo: nil)
        }
        return isEmpty ? [] : Array(AvatarModal.mocks.prefix(limit))
    }

    func fetchPopularAvatars(limit: Int) async throws -> [AvatarModal] {
        await simulateDelay()
        if shouldFail {
            throw NSError(domain: "Network", code: -1, userInfo: nil)
        }
        return isEmpty ? [] : Array(AvatarModal.mocks.prefix(limit))
    }

    func fetchAllAvatars(limit: Int) async throws -> [AvatarModal] {
        await simulateDelay()
        if shouldFail {
            throw NSError(domain: "Network", code: -1, userInfo: nil)
        }
        return isEmpty ? [] : Array(AvatarModal.mocks.prefix(limit))
    }

    func getAvatarsForcategory(category: CharecterOption) async throws -> [AvatarModal] {
        await simulateDelay()
        if shouldFail {
            throw NSError(domain: "Network", code: -1, userInfo: nil)
        }
        return isEmpty ? [] : Array(AvatarModal.mocks.prefix(1))
    }

    func deleteAvatar(avatarId: String) async throws {
        await simulateDelay()
        if shouldFail {
            throw NSError(domain: "Network", code: -1, userInfo: nil)
        }
        print("Mock: Deleted avatar \(avatarId)")
    }

    func incrementClickCount(avatarId: String) async throws {
        await simulateDelay()
        if shouldFail {
            throw NSError(domain: "Network", code: -1, userInfo: nil)
        }
        print("Mock: Incremented click count for avatar \(avatarId)")
    }
}
