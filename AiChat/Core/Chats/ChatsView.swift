//
//  ChatsView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct ChatsView: View {

    @State var avatars: [AvatarModal] = AvatarModal.mocks
    @State var chats: [ChatModal] = ChatModal.mocks
    @State var path: [NavigationPathOption] = []

    var body: some View {
        NavigationStack(path: $path) {
            List {
                if !avatars.isEmpty {
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
}

#Preview {
    ChatsView()
}
