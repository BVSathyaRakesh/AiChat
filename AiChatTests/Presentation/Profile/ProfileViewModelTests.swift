//
//  ProfileViewModelTests.swift
//  AiChatTests
//
//  Created by Claude Code
//

import XCTest
@testable import AiChat

@MainActor
final class ProfileViewModelTests: XCTestCase {

    // MARK: - Load Data Tests

    func testLoadDataSuccess() async throws {
        // Given
        let mockUser = UserModel(
            userId: "test-user-123",
            email: "test@example.com",
            isAnonymous: false,
            profileColorHex: "#007AFF"
        )

        let mockAvatars = [
            AvatarModal(
                avatarId: "avatar-1",
                name: "Test Avatar 1",
                profileImageName: "https://example.com/avatar1.jpg",
                authorId: "test-user-123",
                dateCreated: Date()
            ),
            AvatarModal(
                avatarId: "avatar-2",
                name: "Test Avatar 2",
                profileImageName: "https://example.com/avatar2.jpg",
                authorId: "test-user-123",
                dateCreated: Date().addingTimeInterval(-3600)
            )
        ]

        let fetchUseCase = MockFetchUserAvatarsUseCase(result: .success(mockAvatars))
        let deleteUseCase = MockDeleteAvatarUseCase()
        let getUserUseCase = MockGetCurrentUserUseCase(
            user: mockUser,
            userId: "test-user-123"
        )

        let viewModel = ProfileViewModel(
            fetchUserAvatarsUseCase: fetchUseCase,
            deleteAvatarUseCase: deleteUseCase,
            getCurrentUserUseCase: getUserUseCase
        )

        // When
        await viewModel.loadData()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.hasError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.user?.userId, mockUser.userId)
        XCTAssertEqual(viewModel.myAvatars.count, 2)
        XCTAssertEqual(viewModel.myAvatars[0].avatarId, "avatar-1")
        XCTAssertEqual(viewModel.myAvatars[1].avatarId, "avatar-2")
    }

    func testLoadDataEmptyAvatars() async throws {
        // Given
        let mockUser = UserModel(
            userId: "test-user-123",
            email: "test@example.com",
            isAnonymous: false,
            profileColorHex: "#007AFF"
        )

        let fetchUseCase = MockFetchUserAvatarsUseCase(result: .success([]))
        let deleteUseCase = MockDeleteAvatarUseCase()
        let getUserUseCase = MockGetCurrentUserUseCase(
            user: mockUser,
            userId: "test-user-123"
        )

        let viewModel = ProfileViewModel(
            fetchUserAvatarsUseCase: fetchUseCase,
            deleteAvatarUseCase: deleteUseCase,
            getCurrentUserUseCase: getUserUseCase
        )

        // When
        await viewModel.loadData()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.hasError)
        XCTAssertNotNil(viewModel.user)
        XCTAssertTrue(viewModel.myAvatars.isEmpty)
    }

    func testLoadDataFailure() async throws {
        // Given
        let error = NSError(
            domain: "TestError",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Network error"]
        )

        let fetchUseCase = MockFetchUserAvatarsUseCase(result: .failure(error))
        let deleteUseCase = MockDeleteAvatarUseCase()
        let getUserUseCase = MockGetCurrentUserUseCase(
            user: UserModel(
                userId: "test-user-123",
                email: "test@example.com",
                isAnonymous: false,
                profileColorHex: "#007AFF"
            ),
            userId: "test-user-123"
        )

        let viewModel = ProfileViewModel(
            fetchUserAvatarsUseCase: fetchUseCase,
            deleteAvatarUseCase: deleteUseCase,
            getCurrentUserUseCase: getUserUseCase
        )

        // When
        await viewModel.loadData()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.hasError)
        XCTAssertTrue(viewModel.myAvatars.isEmpty)
    }

    func testLoadDataUserNotAuthenticated() async throws {
        // Given
        let fetchUseCase = MockFetchUserAvatarsUseCase(result: .success([]))
        let deleteUseCase = MockDeleteAvatarUseCase()
        let getUserUseCase = MockGetCurrentUserUseCase(
            user: nil,
            userId: nil,
            shouldFailAuth: true
        )

        let viewModel = ProfileViewModel(
            fetchUserAvatarsUseCase: fetchUseCase,
            deleteAvatarUseCase: deleteUseCase,
            getCurrentUserUseCase: getUserUseCase
        )

        // When
        await viewModel.loadData()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.hasError)
        XCTAssertNil(viewModel.user)
        XCTAssertTrue(viewModel.myAvatars.isEmpty)
    }

    // MARK: - Delete Avatar Tests

    func testDeleteAvatarSuccess() async throws {
        // Given
        let mockAvatars = [
            AvatarModal(
                avatarId: "avatar-1",
                name: "Test Avatar 1",
                profileImageName: "https://example.com/avatar1.jpg",
                authorId: "test-user-123",
                dateCreated: Date()
            ),
            AvatarModal(
                avatarId: "avatar-2",
                name: "Test Avatar 2",
                profileImageName: "https://example.com/avatar2.jpg",
                authorId: "test-user-123",
                dateCreated: Date()
            )
        ]

        let fetchUseCase = MockFetchUserAvatarsUseCase(result: .success(mockAvatars))
        let deleteUseCase = MockDeleteAvatarUseCase()
        let getUserUseCase = MockGetCurrentUserUseCase(
            user: UserModel(
                userId: "test-user-123",
                email: "test@example.com",
                isAnonymous: false,
                profileColorHex: "#007AFF"
            ),
            userId: "test-user-123"
        )

        let viewModel = ProfileViewModel(
            fetchUserAvatarsUseCase: fetchUseCase,
            deleteAvatarUseCase: deleteUseCase,
            getCurrentUserUseCase: getUserUseCase
        )

        await viewModel.loadData()
        let initialCount = viewModel.myAvatars.count

        // When
        viewModel.onDeleteAvtar(indexSet: IndexSet(integer: 0))

        // Then - Alert should be shown
        XCTAssertTrue(viewModel.showDeleteAlert)
        XCTAssertEqual(viewModel.avatarToDelete?.index, 0)
        XCTAssertEqual(viewModel.avatarToDelete?.avatar.avatarId, "avatar-1")

        // When - Confirm deletion
        viewModel.performDelete()

        // Wait for async operation
        try? await Task.sleep(for: .milliseconds(10))

        // Then - Avatar should be removed
        XCTAssertEqual(viewModel.myAvatars.count, initialCount - 1)
        XCTAssertFalse(viewModel.myAvatars.contains(where: { $0.avatarId == "avatar-1" }))
        XCTAssertNotNil(viewModel.resultAlert)
        XCTAssertNil(viewModel.avatarToDelete)
    }

    func testDeleteAvatarFailure() async throws {
        // Given
        let mockAvatars = [
            AvatarModal(
                avatarId: "avatar-1",
                name: "Test Avatar 1",
                profileImageName: "https://example.com/avatar1.jpg",
                authorId: "test-user-123",
                dateCreated: Date()
            )
        ]

        let fetchUseCase = MockFetchUserAvatarsUseCase(result: .success(mockAvatars))
        let deleteError = NSError(
            domain: "TestError",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Delete failed"]
        )
        let deleteUseCase = MockDeleteAvatarUseCase(result: .failure(deleteError))
        let getUserUseCase = MockGetCurrentUserUseCase(
            user: UserModel(
                userId: "test-user-123",
                email: "test@example.com",
                isAnonymous: false,
                profileColorHex: "#007AFF"
            ),
            userId: "test-user-123"
        )

        let viewModel = ProfileViewModel(
            fetchUserAvatarsUseCase: fetchUseCase,
            deleteAvatarUseCase: deleteUseCase,
            getCurrentUserUseCase: getUserUseCase
        )

        await viewModel.loadData()
        let initialCount = viewModel.myAvatars.count

        // When
        viewModel.onDeleteAvtar(indexSet: IndexSet(integer: 0))
        viewModel.performDelete()

        // Wait for async operation
        try? await Task.sleep(for: .milliseconds(10))

        // Then - Avatar should NOT be removed
        XCTAssertEqual(viewModel.myAvatars.count, initialCount)
        XCTAssertNotNil(viewModel.resultAlert)
        XCTAssertNil(viewModel.avatarToDelete)
    }

    func testCancelDeleteAvatar() async throws {
        // Given
        let mockAvatars = [
            AvatarModal(
                avatarId: "avatar-1",
                name: "Test Avatar 1",
                profileImageName: "https://example.com/avatar1.jpg",
                authorId: "test-user-123",
                dateCreated: Date()
            )
        ]

        let fetchUseCase = MockFetchUserAvatarsUseCase(result: .success(mockAvatars))
        let deleteUseCase = MockDeleteAvatarUseCase()
        let getUserUseCase = MockGetCurrentUserUseCase(
            user: UserModel(
                userId: "test-user-123",
                email: "test@example.com",
                isAnonymous: false,
                profileColorHex: "#007AFF"
            ),
            userId: "test-user-123"
        )

        let viewModel = ProfileViewModel(
            fetchUserAvatarsUseCase: fetchUseCase,
            deleteAvatarUseCase: deleteUseCase,
            getCurrentUserUseCase: getUserUseCase
        )

        await viewModel.loadData()

        // When
        viewModel.onDeleteAvtar(indexSet: IndexSet(integer: 0))
        XCTAssertTrue(viewModel.showDeleteAlert)

        // Cancel deletion
        viewModel.showDeleteAlert = false
        viewModel.avatarToDelete = nil

        // Then
        XCTAssertFalse(viewModel.showDeleteAlert)
        XCTAssertNil(viewModel.avatarToDelete)
        XCTAssertEqual(viewModel.myAvatars.count, 1)
    }

    // MARK: - UI State Tests

    func testToggleSettings() async throws {
        // Given
        let fetchUseCase = MockFetchUserAvatarsUseCase(result: .success([]))
        let deleteUseCase = MockDeleteAvatarUseCase()
        let getUserUseCase = MockGetCurrentUserUseCase(
            user: UserModel(
                userId: "test-user-123",
                email: "test@example.com",
                isAnonymous: false,
                profileColorHex: "#007AFF"
            ),
            userId: "test-user-123"
        )

        let viewModel = ProfileViewModel(
            fetchUserAvatarsUseCase: fetchUseCase,
            deleteAvatarUseCase: deleteUseCase,
            getCurrentUserUseCase: getUserUseCase
        )
        
        // Wait for async operation
        try? await Task.sleep(for: .milliseconds(10))

        // When
        XCTAssertFalse(viewModel.showSettings)
        viewModel.profileButtonAction()

        // Then
        XCTAssertTrue(viewModel.showSettings)

        // Toggle again
        viewModel.profileButtonAction()
        XCTAssertFalse(viewModel.showSettings)
    }

    func testToggleCreateNewAvatar() async throws {
        // Given
        let fetchUseCase = MockFetchUserAvatarsUseCase(result: .success([]))
        let deleteUseCase = MockDeleteAvatarUseCase()
        let getUserUseCase = MockGetCurrentUserUseCase(
            user: UserModel(
                userId: "test-user-123",
                email: "test@example.com",
                isAnonymous: false,
                profileColorHex: "#007AFF"
            ),
            userId: "test-user-123"
        )

        let viewModel = ProfileViewModel(
            fetchUserAvatarsUseCase: fetchUseCase,
            deleteAvatarUseCase: deleteUseCase,
            getCurrentUserUseCase: getUserUseCase
        )

        // Wait for async operation
        try? await Task.sleep(for: .milliseconds(10))

        // When
        XCTAssertFalse(viewModel.createNewAvatarView)
        viewModel.newAvatarButtonPressed()

        // Then
        XCTAssertTrue(viewModel.createNewAvatarView)

        // Toggle again
        viewModel.newAvatarButtonPressed()
        XCTAssertFalse(viewModel.createNewAvatarView)
    }

    func testRetryLoadData() async throws {
        // Given
        let fetchUseCase = MockFetchUserAvatarsUseCase(result: .success([]))
        let deleteUseCase = MockDeleteAvatarUseCase()
        let getUserUseCase = MockGetCurrentUserUseCase(
            user: UserModel(
                userId: "test-user-123",
                email: "test@example.com",
                isAnonymous: false,
                profileColorHex: "#007AFF"
            ),
            userId: "test-user-123"
        )

        let viewModel = ProfileViewModel(
            fetchUserAvatarsUseCase: fetchUseCase,
            deleteAvatarUseCase: deleteUseCase,
            getCurrentUserUseCase: getUserUseCase
        )

        // When
        viewModel.retryLoadData()

        // Wait for async operation
        try? await Task.sleep(for: .milliseconds(10))

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.hasError)
    }

    // MARK: - Initial State Tests

    func testInitialState() async throws {
        // Given
        let fetchUseCase = MockFetchUserAvatarsUseCase(result: .success([]))
        let deleteUseCase = MockDeleteAvatarUseCase()
        let getUserUseCase = MockGetCurrentUserUseCase(
            user: UserModel(
                userId: "test-user-123",
                email: "test@example.com",
                isAnonymous: false,
                profileColorHex: "#007AFF"
            ),
            userId: "test-user-123"
        )

        // When
        let viewModel = ProfileViewModel(
            fetchUserAvatarsUseCase: fetchUseCase,
            deleteAvatarUseCase: deleteUseCase,
            getCurrentUserUseCase: getUserUseCase
        )

        // Then
        XCTAssertNil(viewModel.user)
        XCTAssertTrue(viewModel.myAvatars.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.hasError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showSettings)
        XCTAssertFalse(viewModel.createNewAvatarView)
        XCTAssertFalse(viewModel.showDeleteAlert)
        XCTAssertNil(viewModel.avatarToDelete)
        XCTAssertNil(viewModel.resultAlert)

        // Keep viewModel alive and let observation cleanup properly
        try? await Task.sleep(for: .milliseconds(10))
    }
}

// MARK: - Mock Use Cases

class MockFetchUserAvatarsUseCase: FetchUserAvatarsUseCase {
    private let result: Result<[AvatarModal], Error>

    init(result: Result<[AvatarModal], Error>) {
        self.result = result
    }

    func execute(userId: String) async throws -> [AvatarModal] {
        switch result {
        case .success(let avatars):
            return avatars
        case .failure(let error):
            throw error
        }
    }
}

class MockDeleteAvatarUseCase: DeleteAvatarUseCase {
    private let result: Result<Void, Error>

    init(result: Result<Void, Error> = .success(())) {
        self.result = result
    }

    func execute(avatarId: String) async throws {
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}

class MockGetCurrentUserUseCase: GetCurrentUserUseCase {
    private let user: UserModel?
    private let userId: String?
    private let shouldFailAuth: Bool

    init(user: UserModel?, userId: String?, shouldFailAuth: Bool = false) {
        self.user = user
        self.userId = userId
        self.shouldFailAuth = shouldFailAuth
    }

    func execute() async throws -> UserModel {
        if shouldFailAuth {
            throw DefaultGetCurrentUserUseCase.AuthError.notAuthenticated
        }

        guard let user = user else {
            throw UserError.userNotFound
        }

        return user
    }

    func getUserId() throws -> String {
        if shouldFailAuth {
            throw DefaultGetCurrentUserUseCase.AuthError.notAuthenticated
        }

        guard let userId = userId else {
            throw UserError.userNotFound
        }

        return userId
    }
}
