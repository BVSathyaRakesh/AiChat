//
//  ChatDetailsView.swift
//  AiChat
//
//  Created by Sathya Kumar on 22/06/26.
//

import SwiftUI

struct ChatDetailsView: View {
    
    @State private var chatMessages: [ChatMessageModal] = ChatMessageModal.mocks
    @State private var avatarmodel: AvatarModal? = AvatarModal.mock
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(chatMessages) { message in
                        ChatBubbleViewBuilder(
                            message: message,
                            isCurrentuser: message.isFromCurrentUser,
                            imageName: message.isFromCurrentUser ? nil : avatarmodel?.profileImageName
                        )
                     }
                }
            }
            .padding()
            Rectangle()
                .frame(height: 50)
        }
    }
}

#Preview {
    ChatDetailsView()
}
