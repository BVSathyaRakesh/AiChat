//
//  ProfileView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(UserManager.self) private var userManager
    @State private var showSettings: Bool = false
    @State private var user: UserModel? = .mock
    @State private var createNewAvatarView: Bool = false
    @State private var myAVatars: [AvatarModal] = []
    @State private var isLoading: Bool = true
    @State var path: [NavigationPathOption] = []
  
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
        .fullScreenCover(isPresented: $createNewAvatarView) {
            CreateAvatarView()
        }
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
            if myAVatars.isEmpty {
                Group {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Click + To Create Your First Avatar")
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(50)
                .frame(maxWidth: .infinity)
                .font(.body)
                .foregroundStyle(.secondary)
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
        myAVatars.remove(at: index)
    }
    
    private func loadData() async {
        user = userManager.currentuser
        try? await Task.sleep(for: .seconds(5))
        isLoading = false
        myAVatars = AvatarModal.mocks
    }
}

#Preview {
    ProfileView()
        .environment(AppState())
        .environment(UserManager(userService: MockUserService(user: UserModel.mock)))
}
