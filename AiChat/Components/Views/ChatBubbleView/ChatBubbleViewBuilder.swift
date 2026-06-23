//
//  ChatBubbleViewBuilder.swift
//  AiChat
//
//  Created by Sathya Kumar on 22/06/26.
//

import SwiftUI

struct ChatBubbleViewBuilder: View {
    
    var message: ChatMessageModal = ChatMessageModal.mock
    var isCurrentuser: Bool = false
    var imageName: String?
    var action: (() -> Void)?
    
    var body: some View {
        ChatBubbleView(
            text: message.content ?? "",
            textColor: isCurrentuser ? .white : .primary,
            backgroundColor: isCurrentuser ? .accent : Color(
                uiColor: .systemGray5
            ), showImage: isCurrentuser ? false : true,
            imageName: imageName,
            action: action
        )
        .frame(maxWidth: .infinity, alignment: isCurrentuser ? .trailing : .leading)
        .padding(.leading, isCurrentuser ? 15 : 0)
        .padding(.vertical, isCurrentuser ? 0 : 15)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 24) {
            ChatBubbleViewBuilder(
                message: ChatMessageModal(
                    id: UUID().uuidString,
                    chatId: UUID().uuidString,
                    authorId: UUID().uuidString,
                    content: "This is some longer text that goes here on multiple lines and keeps going to another line!",
                    seenByIds: nil,
                    dateCreated: .now
                )
            )
            ChatBubbleViewBuilder(isCurrentuser: true)
            ChatBubbleViewBuilder()
            ChatBubbleViewBuilder(
                message: ChatMessageModal(
                    id: UUID().uuidString,
                    chatId: UUID().uuidString,
                    authorId: UUID().uuidString,
                    content: "This is some longer text that goes here on multiple lines and keeps going to another line!",
                    seenByIds: nil,
                    dateCreated: .now
                ), isCurrentuser: true
            )
        }
        .padding(12)
    }
}
