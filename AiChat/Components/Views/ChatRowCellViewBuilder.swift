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
        return lastMessage.hasSeenBy(userId: currentUserId)
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

#Preview {
    
    VStack {
        ChatRowCellViewBuilder(chat: .mock, getAvatar: {
            try? await Task.sleep(for: .seconds(3))
            return .mock
        }, getLastMessage: {
            try? await Task.sleep(for: .seconds(3))
            return.mock
        })
        
        ChatRowCellViewBuilder(chat: .mock, getAvatar: {
            return .mock
        }, getLastMessage: {
            return.mock
        })
        
        ChatRowCellViewBuilder(chat: .mock, getAvatar: {
            return nil
        }, getLastMessage: {
            return nil
        })
    }
   
}
