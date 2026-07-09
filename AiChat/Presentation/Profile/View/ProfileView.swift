//
//  ProfileView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct ProfileView: View {

    @State var viewModel: ProfileViewModel

    // MARK: - Navigation State (View concern)
    @State private var path: [NavigationPathOption] = []

    var body: some View {
        NavigationStack(path: $path) {
            List {
                userProfileSection
                myAvatarSection
            }
            .navigationTitle("Profile")
            .navigationDestinationForModule(path: $path)
            .task {
                await viewModel.loadData()
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
        .sheet(isPresented: $viewModel.showSettings) {
           SettingsView()
        }
        .fullScreenCover(isPresented: $viewModel.createNewAvatarView, onDismiss: {
            Task {
                await viewModel.loadData()
            }
        }, content: {
            CreateAvatarView()
        })
        .overlay {
            if viewModel.showDeleteAlert, let toDelete = viewModel.avatarToDelete {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.showDeleteAlert = false
                            viewModel.avatarToDelete = nil
                        }

                    CustomDeleteAlert(
                        title: "Delete Avatar",
                        message: "Are you sure you want to delete \"\(toDelete.avatar.name ?? "this avatar")\"?",
                        deleteAction: {
                            viewModel.showDeleteAlert = false
                            viewModel.performDelete()
                        },
                        cancelAction: {
                            viewModel.showDeleteAlert = false
                            viewModel.avatarToDelete = nil
                        }
                    )
                }
            }
        }
        .showCustomAlert(type: .alert, alert: $viewModel.resultAlert)
    }

    private var userProfileSection: some View {
        Section {
            ZStack {
                Circle()
                    .fill(viewModel.user?.profileColor ?? .accent)
            }
            .frame(width: 100, height: 100)
            .frame(maxWidth: .infinity)
            .removeListRowFormatting()
        }
    }

    private var myAvatarSection: some View {
        Section {
            if viewModel.hasError {
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
            } else if viewModel.myAvatars.isEmpty {
                Group {
                    if viewModel.isLoading {
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
                ForEach(viewModel.myAvatars, id: \.self) { avatar in
                    CustomListsCellView(
                        title: avatar.name,
                        subtitle: nil,
                        imageName: avatar.profileImageName
                    )
                    .anyButton(.highlight, action: {
                        path.append(.chat(avatarId: avatar.avatarId, chat: nil))
                    })
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .onDelete { indexset in
                    viewModel.onDeleteAvtar(indexSet: indexset)
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
                viewModel.profileButtonAction()
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
                    viewModel.newAvatarButtonPressed()
                }
        }
    }
}

// MARK: - Previews
 #Preview("Loaded - With Data") {
     ProfileView(viewModel: {
         let viewModel = ProfileViewModel(
             fetchUserAvatarsUseCase: MockFetchUserAvatarsUseCase(),
             deleteAvatarUseCase: MockDeleteAvatarUseCase(),
             getCurrentUserUseCase: MockGetCurrentUserUseCase()
         )

         Task {
             try? await Task.sleep(for: .milliseconds(500))
             await viewModel.loadData()
         }

         return viewModel
     }())
     .previewEnvironment()
 }

 #Preview("Error - No Connection") {
     ProfileView(viewModel: {
         let viewModel = ProfileViewModel(
             fetchUserAvatarsUseCase: MockFetchUserAvatarsUseCaseError(),
             deleteAvatarUseCase: MockDeleteAvatarUseCase(),
             getCurrentUserUseCase: MockGetCurrentUserUseCase()
         )

         Task {
             try? await Task.sleep(for: .seconds(1))
             await viewModel.loadData()
         }

         return viewModel
     }())
     .previewEnvironment()
 }

 #Preview("Empty - No Data") {
     ProfileView(viewModel: {
         let viewModel = ProfileViewModel(
             fetchUserAvatarsUseCase: MockFetchUserAvatarsUseCaseEmpty(),
             deleteAvatarUseCase: MockDeleteAvatarUseCase(),
             getCurrentUserUseCase: MockGetCurrentUserUseCase()
         )

         Task {
             try? await Task.sleep(for: .milliseconds(500))
             await viewModel.loadData()
         }

         return viewModel
     }())
     .previewEnvironment()
 }

// MARK: - Mock Use Cases for Previews
 private class MockFetchUserAvatarsUseCase: FetchUserAvatarsUseCase {
     func execute(userId: String) async throws -> [AvatarModal] {
         // Return mock data
         return [
             AvatarModal(
                 avatarId: "1",
                 name: "AI Assistant",
                 profileImageName: Constants.randomImage,
                 authorId: userId,
                 dateCreated: Date()
             ),
             AvatarModal(
                 avatarId: "2",
                 name: "Code Helper",
                 profileImageName: Constants.randomImage,
                 authorId: userId,
                 dateCreated: Date()
             )
         ]
     }
 }

 private class MockFetchUserAvatarsUseCaseError: FetchUserAvatarsUseCase {
     func execute(userId: String) async throws -> [AvatarModal] {
         throw NSError(domain: "Network", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load avatars"])
     }
 }

 private class MockFetchUserAvatarsUseCaseEmpty: FetchUserAvatarsUseCase {
     func execute(userId: String) async throws -> [AvatarModal] {
         return []
     }
 }

 private class MockDeleteAvatarUseCase: DeleteAvatarUseCase {
     func execute(avatarId: String) async throws {
         // Simulate deletion
         try? await Task.sleep(for: .milliseconds(500))
     }
 }

 private class MockGetCurrentUserUseCase: GetCurrentUserUseCase {
     func execute() async throws -> UserModel {
         return UserModel(
             userId: "mock-user",
             email: "user@example.com",
             isAnonymous: false,
             profileColorHex: "#007AFF"
         )
     }

     func getUserId() throws -> String {
         return "mock-user"
     }
 }
