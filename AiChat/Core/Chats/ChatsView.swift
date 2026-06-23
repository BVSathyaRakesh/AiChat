//
//  ChatsView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct ChatsView: View {

    @State var chats: [ChatModal] = ChatModal.mocks
    @State private var selectedChat: ChatModal?
    @State var path: [NavigationPathOption] = []

    var body: some View {
        NavigationStack(path: $path) {
            List {
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
            .removeListRowFormatting()
            .navigationDestinationForModule(path: $path)
            .navigationTitle("Chats")
            .onAppear {
                UIScrollView.appearance().delaysContentTouches = false
            }
        }
    }
}

#Preview {
    ChatsView()
}
