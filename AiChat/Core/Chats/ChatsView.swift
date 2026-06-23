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

    var body: some View {
        NavigationStack {
            List {
                ForEach(chats, id: \.self) { chat in
                    ChatRowCellViewBuilder(
                        currentUserId: nil,
                        chat: chat,
                        getAvatar: {
                            try? await Task.sleep(for: .seconds(3))
                            return .mock
                        },
                        getLastMessage: {
                            try? await Task.sleep(for: .seconds(3))
                            return.mock
                        }
                    )
                    .anyButton(.highlight) {
                        selectedChat = chat
                    }
                }
            }
            .removeListRowFormatting()
            .navigationTitle("Chats")
            .navigationDestination(item: $selectedChat) { _ in
                ChatDetailsView()
            }
            .onAppear {
                UIScrollView.appearance().delaysContentTouches = false
            }
        }
    }
}

#Preview {
    ChatsView()
}
