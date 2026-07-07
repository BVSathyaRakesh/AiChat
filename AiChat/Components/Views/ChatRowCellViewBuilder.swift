//
//  ChatRowCellViewBuilder.swift
//  AiChat
//
//  Created by Sathya Kumar on 19/06/26.
//

import SwiftUI

struct ChatRowCellViewBuilder: View {
    
    var currentUserId: String? = ""
    var chat: ChatModal = .mock
    var getAvatar: ()  async -> AvatarModal?
    var getLastMessage: () async -> ChatMessageModal?
    
    @State private var avatar: AvatarModal?
    @State private var lastMessage: ChatMessageModal?
    
    @State private var didLoadAvatar: Bool = false
    @State private var didLoadLastMessage: Bool = false
    
    var isLoading: Bool {
        if didLoadAvatar && didLoadLastMessage {
            return false
        }
        return true
    }
    
    private var hasNewChat: Bool {
        guard let lastMessage, let currentUserId else { return false}
        return !lastMessage.hasSeenBy(userId: currentUserId)
    }
    
    private var subHeadline: String {
        if isLoading {
            return "xxxx xxxx xxxx xxxx"
        }

        if avatar == nil && lastMessage == nil {
            return "Error"
        }

        return lastMessage?.content?.message ?? "No Messages Yet!"
    }
    
    var body: some View {
        ChatRowCellView(
            imageName: avatar?.profileImageName,
            title: isLoading ? "xxxx xxxx" : avatar?.name,
            subTitle: subHeadline,
            hasNewChat: isLoading ? false : hasNewChat
        )
        .redacted(reason: isLoading ? .placeholder: [])
        .task {
           avatar =  await getAvatar()
           didLoadAvatar = true
        }
        .task {
            lastMessage = await getLastMessage()
            didLoadLastMessage = true
        }
    }
}

#Preview("Loading & New Badge") {
    let mockUserId = UserAuthInfo.mock().uid
    let mockAvatarId = AvatarModal.mock.avatarId
    let chatId = "\(mockUserId)_\(mockAvatarId)"

    // Message with seenByIds that does NOT include current user (should show NEW)
    let unseenMessage = ChatMessageModal(
        id: UUID().uuidString,
        chatId: chatId,
        authorId: mockAvatarId,
        content: .assistant("This is a new message!"),
        seenByIds: [], // Empty - current user hasn't seen it
        dateCreated: Date()
    )

    // Message with seenByIds that includes current user (should NOT show NEW)
    let seenMessage = ChatMessageModal(
        id: UUID().uuidString,
        chatId: chatId,
        authorId: mockAvatarId,
        content: .assistant("This is an old message"),
        seenByIds: [mockUserId], // Current user has seen it
        dateCreated: Date()
    )

    return List {
        // Loading state
        ChatRowCellViewBuilder(
            currentUserId: mockUserId,
            chat: .mock,
            getAvatar: {
                try? await Task.sleep(for: .seconds(2))
                return .mock
            },
            getLastMessage: {
                try? await Task.sleep(for: .seconds(2))
                return unseenMessage
            }
        )
        .removeListRowFormatting()

        // New message - should show NEW badge
        ChatRowCellViewBuilder(
            currentUserId: mockUserId,
            chat: .mock,
            getAvatar: { .mock },
            getLastMessage: { unseenMessage }
        )
        .removeListRowFormatting()

        // Seen message - should NOT show NEW badge
        ChatRowCellViewBuilder(
            currentUserId: mockUserId,
            chat: .mock,
            getAvatar: { .mock },
            getLastMessage: { seenMessage }
        )
        .removeListRowFormatting()

        // Error state
        ChatRowCellViewBuilder(
            currentUserId: mockUserId,
            chat: .mock,
            getAvatar: { nil },
            getLastMessage: { nil }
        )
        .removeListRowFormatting()
    }
}
