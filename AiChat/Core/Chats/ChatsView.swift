//
//  ChatsView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct ChatsView: View {

    @Environment(AvatarManager.self) private var avatarManager
    @State var avatars: [AvatarModal] = []
    @State var chats: [ChatModal] = ChatModal.mocks
    @State var path: [NavigationPathOption] = []
    @State private var isLoadingAvatars = false
    @State private var alert: AnyAppAlert?

    var body: some View {
        NavigationStack(path: $path) {
            List {
                if isLoadingAvatars {
                    loadingAvatarsSection
                } else if !avatars.isEmpty {
                    recentAvatarsSection
                }
                chatSection
            }
            .removeListRowFormatting()
            .navigationDestinationForModule(path: $path)
            .navigationTitle("Chats")
            .onAppear {
                UIScrollView.appearance().delaysContentTouches = false
            }
        }
        .showCustomAlert(alert: $alert)
        .task {
            await loadRecentAvatars()
        }
    }
    
    private var loadingAvatarsSection: some View {
        Section {
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)
                .removeListRowFormatting()
        } header: {
            Text("Recents")
        }
    }

    private var emptyAvatarsSection: some View {
        Text("Your Recent Avatars will appear here!")
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .removeListRowFormatting()
    }
    
    private var recentAvatarsSection: some View {
        Section {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(avatars, id: \.self) { avatar in
                        VStack(spacing: 8) {
                            if let imageName = avatar.profileImageName {
                                ImageLoaderView(
                                    urlString: imageName
                                )
                                .aspectRatio(1, contentMode: .fit)
                                .clipShape(.circle)
                            }
                            if let title = avatar.name {
                                Text(title)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .anyButton {
                            path.append(.chat(avatarId: avatar.avatarId))
                        }
                    }
                    .padding(12)
                }
            }
            .frame(height: 120)
            .scrollIndicators(.hidden)
            .removeListRowFormatting()
        } header: {
            Text("Recents")
        }
    }
    
    private var chatSection: some View {
        Section {
            if chats.isEmpty {
                Text("Your chats will appear here!")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .removeListRowFormatting()
            } else {
                ForEach(chats, id: \.self) { chat in
                    ChatRowCellViewBuilder(
                        currentUserId: nil,
                        chat: chat,
                        getAvatar: {
                            try? await Task.sleep(for: .seconds(1))
                            return AvatarModal.mocks.randomElement()!
                        },
                        getLastMessage: {
                            try? await Task.sleep(for: .seconds(1))
                            return ChatMessageModal.mocks.randomElement()!
                        }
                    )
                    .anyButton(.highlight) {
                        path.append(.chat(avatarId: chat.avatarId))
                    }
                }
            }
        } header: {
            Text("Chats")
        }
    }

    private func loadRecentAvatars() async {
        isLoadingAvatars = true
        defer { isLoadingAvatars = false }

        do {
            // TODO: Replace with actual user ID when authentication is implemented
            avatars = try await avatarManager.fetchUserAvatars(userId: "current_user_id")
        } catch {
            alert = AnyAppAlert(error: error)
        }
    }
}

#Preview {
    ChatsView()
        .environment(AvatarManager(service: MockAvatarService()))
}
