//
//  ProfileViewModel.swift
//  AiChat
//
//  Created by Sathya Kumar on 09/07/26.
//

import  SwiftUI
 
@Observable
@MainActor
class ProfileViewModel {
    
//    private let  userManager: UserManager
//    private let  avatarManager: AvatarManager
//    private let  authManager: AuthManager
    
    // MARK: - Dependencies (Use Cases)
    private let fetchUserAvatarsUseCase: FetchUserAvatarsUseCase
    private let deleteAvatarUseCase: DeleteAvatarUseCase
    private let getCurrentUserUseCase: GetCurrentUserUseCase
    
    // Data State
    private(set) var user: UserModel?
    private(set) var myAvatars: [AvatarModal] = []
    
    // Loading State
    private(set) var isLoading: Bool = false
    private(set) var hasError: Bool = false
    private(set) var errorMessage: String?
    
    // UI State (View can read and write these)
    var showSettings: Bool = false
    var createNewAvatarView: Bool = false
    var showDeleteAlert: Bool = false
    var avatarToDelete: (index: Int, avatar: AvatarModal)?
    var resultAlert: AnyAppAlert?
    
    // MARK: - Initialization
    init(
        fetchUserAvatarsUseCase: FetchUserAvatarsUseCase,
        deleteAvatarUseCase: DeleteAvatarUseCase,
        getCurrentUserUseCase: GetCurrentUserUseCase
    ) {
        self.fetchUserAvatarsUseCase = fetchUserAvatarsUseCase
        self.deleteAvatarUseCase = deleteAvatarUseCase
        self.getCurrentUserUseCase = getCurrentUserUseCase
    }
    
    func profileButtonAction() {
        showSettings.toggle()
    }
    
    func newAvatarButtonPressed() {
        createNewAvatarView.toggle()
    }
    
    func onDeleteAvtar(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let avatar = myAvatars[index]
        avatarToDelete = (index, avatar)
        showDeleteAlert = true
    }
    
    func performDelete() {
        guard let toDelete = avatarToDelete else { return }
        Task {
            do {
                // Delete avatar via use case
                try await deleteAvatarUseCase.execute(avatarId: toDelete.avatar.avatarId)
                myAvatars.remove(at: toDelete.index)
                
                resultAlert = AnyAppAlert(
                    title: "Success",
                    subtitle: "Avatar deleted successfully"
                )
            } catch {
                resultAlert = AnyAppAlert(error: error)
            }
            
            avatarToDelete = nil
        }
    }
    
    func loadData() async {
        isLoading = true
        hasError = false
        do {
            // Get current user
            user = try await getCurrentUserUseCase.execute()
            
            // Get user ID
            let userId = try getCurrentUserUseCase.getUserId()
            // Fetch user's avatars from Firestore
            myAvatars = try await fetchUserAvatarsUseCase.execute(userId: userId)
        } catch {
            hasError = true
            myAvatars = []
        }
        isLoading = false
    }
    
    func retryLoadData() {
        Task {
            await loadData()
        }
    }
    
}
