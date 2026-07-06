//
//  ChatsView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct ChatsView: View {

    @Environment(AvatarManager.self) private var avatarManager
    @Environment(ChatManager.self) private var chatManager
    @Environment(AuthManager.self) private var authManager
    @State var avatars: [AvatarModal] = []
    @State var chats: [ChatModal] = []
    @State var path: [NavigationPathOption] = []
    @State private var isLoadingAvatars = false
    @State private var isLoadingChats = false
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
            await loadChats()
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
                            path.append(.chat(avatarId: avatar.avatarId, chat: nil))
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
            if isLoadingChats {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .removeListRowFormatting()
            } else if chats.isEmpty {
                Text("Your chats will appear here!")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .removeListRowFormatting()
            } else {
                ForEach(chats, id: \.self) { chat in
                    ChatRowCellViewBuilder(
                        currentUserId: try? authManager.getAuthId(),
                        chat: chat,
                        getAvatar: {
                            try? await avatarManager.getAvatarById(avatarId: chat.avatarId)
                        },
                        getLastMessage: {
                            try? await chatManager.getLastMessage(chatId: chat.id)
                        }
                    )
                    .anyButton(.highlight) {
                        path.append(.chat(avatarId: chat.avatarId, chat: chat))
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
            avatars = try  await avatarManager.getRecentAvatars()
        } catch {
            alert = AnyAppAlert(error: error)
        }
    }

    private func loadChats() async {
        isLoadingChats = true
        defer { isLoadingChats = false }

        do {
            let userId = try authManager.getAuthId()
            let fetchedChats = try await chatManager.getUserChats(userId: userId)
            chats = fetchedChats.sortedByKeyPath(\.dateModified, ascending: false)
        } catch {
            alert = AnyAppAlert(error: error)
        }
    }
}

#Preview("Has data") {
    ChatsView()
        .previewEnvironment()
}

#Preview("No data") {
    ChatsView()
        .environment(
            AvatarManager(
                service: MockAvatarService(avatars: []),
                local: MockLocalAvatarPersistence(avatars: [])
            )
        )
        .environment(ChatManager(chatService: MockChatMessageService(chats: [])))
        .previewEnvironment()
}

#Preview("Slow loading chats") {
    ChatsView()
        .environment(ChatManager(chatService: MockChatMessageService(delay: 5)))
        .previewEnvironment()
}
