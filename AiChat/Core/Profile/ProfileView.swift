//
//  ProfileView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct ProfileView: View {

    @Environment(UserManager.self) private var userManager
    @Environment(AvatarManager.self) private var avatarManager
    @Environment(AuthManager.self) private var authManager
    @State private var showSettings: Bool = false
    @State private var user: UserModel? = .mock
    @State private var createNewAvatarView: Bool = false
    @State private var myAVatars: [AvatarModal] = []
    @State private var isLoading: Bool = true
    @State private var hasError: Bool = false
    @State var path: [NavigationPathOption] = []
    @State private var showDeleteAlert: Bool = false
    @State private var resultAlert: AnyAppAlert?
    @State private var avatarToDelete: (index: Int, avatar: AvatarModal)?
  
    var body: some View {
        NavigationStack(path: $path) {
            List {
                userProfileSection
                myAvatarSection
            }
            .navigationTitle("Profile")
            .navigationDestinationForModule(path: $path)
            .task {
                await loadData()
            }
            .onAppear {
                UIScrollView.appearance().delaysContentTouches = false
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    profileButton
                }
            }
        }
        .sheet(isPresented: $showSettings) {
           SettingsView()
        }
        .fullScreenCover(isPresented: $createNewAvatarView, onDismiss: {
            Task {
               await loadData()
            }
        }, content: {
            CreateAvatarView()
        })
        .overlay {
            if showDeleteAlert, let toDelete = avatarToDelete {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showDeleteAlert = false
                            avatarToDelete = nil
                        }

                    CustomDeleteAlert(
                        title: "Delete Avatar",
                        message: "Are you sure you want to delete \"\(toDelete.avatar.name ?? "this avatar")\"?",
                        deleteAction: {
                            showDeleteAlert = false
                            performDelete()
                        },
                        cancelAction: {
                            showDeleteAlert = false
                            avatarToDelete = nil
                        }
                    )
                }
            }
        }
        .showCustomAlert(type: .alert, alert: $resultAlert)
    }
    
    private var userProfileSection: some View {
        Section {
            ZStack {
                Circle()
                    .fill(user?.profileColor ?? .accent)
            }
            .frame(width: 100, height: 100)
            .frame(maxWidth: .infinity)
            .removeListRowFormatting()
        }
    }
    
    private var myAvatarSection: some View {
        Section {
            if hasError {
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Text("No Avatars Found")
                            .font(.headline)
                        Text("😢")
                            .font(.system(size: 20))
                    }
                }
                .padding(50)
                .frame(maxWidth: .infinity)
                .removeListRowFormatting()
            } else if myAVatars.isEmpty {
                Group {
                    if isLoading {
                        ProgressView()
                    } else {
                        VStack(spacing: 12) {
                            Text("🤖")
                                .font(.system(size: 60))
                            Text("No Avatars Found")
                                .font(.headline)
                            Text("Click + To Create Your First Avatar")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(50)
                .frame(maxWidth: .infinity)
                .removeListRowFormatting()
            } else {
                ForEach(myAVatars, id: \.self) { avatar in
                    CustomListsCellView(
                        title: avatar.name,
                        subtitle: nil,
                        imageName: avatar.profileImageName
                    )
                    .anyButton(.highlight, action: {
                        path.append(.chat(avatarId: avatar.avatarId))
                    })
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .onDelete { indexset in
                    onDeleteAvtar(indexSet: indexset)
                }
            }

        } header: {
           headerText
        }
    }
    
    private var  profileButton: some View {
        Image(systemName: "gear")
            .foregroundStyle(.accent)
            .anyButton {
                profileButtonAction()
            }
    }
    
    private var headerText: some View {
        HStack {
            Text("My Avatars")
            Spacer()
            Image(systemName: "plus.circle.fill")
                .font(.title)
                .foregroundStyle(.accent)
                .anyButton {
                    newAvatarButtonPressed()
                }
        }
    }
    
    private func profileButtonAction() {
        showSettings.toggle()
    }
    
    private func newAvatarButtonPressed() {
        createNewAvatarView.toggle()
    }
    
    private func onDeleteAvtar(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let avatar = myAVatars[index]
        avatarToDelete = (index, avatar)
        showDeleteAlert = true
    }

    private func performDelete() {
        guard let toDelete = avatarToDelete else { return }

        Task {
            do {
                try await avatarManager.deleteAvatar(avatarId: toDelete.avatar.avatarId)
                myAVatars.remove(at: toDelete.index)

                resultAlert = AnyAppAlert(
                    title: "Success",
                    subtitle: "Avatar deleted successfully"
                )

                print("✅ Avatar deleted successfully")
            } catch {
                resultAlert = AnyAppAlert(error: error)
                print("❌ Error deleting avatar: \(error.localizedDescription)")
            }

            avatarToDelete = nil
        }
    }

    private func loadData() async {
        isLoading = true
        hasError = false
        user = userManager.currentuser
        do {
            let uid = try authManager.getAuthId()
            // Fetch user's avatars from Firestore
            myAVatars = try await avatarManager.fetchUserAvatars(userId: uid)
            print("✅ Loaded \(myAVatars.count) avatars")
        } catch {
            hasError = true
            print("❌ Error loading avatars: \(error.localizedDescription)")
            myAVatars = []
        }
        isLoading = false
    }

    private func retryLoadData() {
        Task {
            await loadData()
        }
    }
}

#Preview("Loaded - With Data") {
    ProfileView()
        .previewEnvironment(delay: 0.5)
}

#Preview("Error - No Connection") {
    ProfileView()
        .previewEnvironment(shouldFail: true, delay: 1.0)
}

#Preview("Empty - No Data") {
    ProfileView()
        .previewEnvironment(isEmpty: true, delay: 0.5)
}
