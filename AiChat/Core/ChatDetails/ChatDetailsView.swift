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
    @State private var textFieldText: String = ""
    @State private var scrollPosition: String?
    @State private var showAlert: AnyAppAlert?
    @State private var showConfirmation: AnyAppAlert?
    @State private var showProfileModal: Bool = false
   
    var body: some View {
        VStack(spacing: 0) {
            scrollViewSection
            textFieldSection
        }
        .onAppear {
            UIScrollView.appearance().delaysContentTouches = false
        }
        .navigationTitle(avatarmodel?.name ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Image(systemName: "ellipsis")
                    .padding(8)
                    .anyButton {
                        showConfirmationDialog()
                    }
                    .disabled(showProfileModal)
            }
        }
        .navigationBarBackButtonHidden(showProfileModal)
        .showCustomAlert(alert: $showAlert)
        .showCustomAlert(type: .confirmationDialog, alert: $showConfirmation)
        .customModal(isPresented: $showProfileModal) {
            if let avatarmodel {
                ProfileModalview(
                    imageName: avatarmodel.profileImageName,
                    title: avatarmodel.name,
                    subtitle: avatarmodel.charcterOption?.rawValue.capitalized,
                    headline: avatarmodel.charecterDescription,
                    onMarkPressed: { showProfileModal = false }
                )
            }
        }
    }
    
    private var scrollViewSection: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(chatMessages) { message in
                    ChatBubbleViewBuilder(
                        message: message,
                        isCurrentuser: message.isFromCurrentUser,
                        imageName: message.isFromCurrentUser ? nil : avatarmodel?.profileImageName,
                        action: showProfileModalScreen
                    )
                    .id(message.id)
                 }
            }
            .rotationEffect(.degrees(180))
        }
        .padding(8)
        .rotationEffect(.degrees(180))
        .scrollPosition(id: $scrollPosition, anchor: .center)
        .animation(.default, value: chatMessages.count)
        .animation(.default, value: scrollPosition)
    }
    
    private var textFieldSection: some View {
        TextField("Say something....", text: $textFieldText)
            .keyboardType(.alphabet)
            .autocorrectionDisabled()
            .padding(12)
            .padding(.trailing, 60)
            .overlay(
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .padding(.trailing, 4)
                    .foregroundStyle(.accent)
                    .anyButton {
                       sendMessage()
                    }
                , alignment: .trailing
             )
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color(uiColor: .systemBackground))
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                }
             )
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(uiColor: .secondarySystemBackground))
    }

    private func sendMessage() {
        do {
            try TextValidationHelper.validateTextField(text: textFieldText)
            
            let message = ChatMessageModal(
                id: UUID().uuidString,
                chatId: UUID().uuidString,
                authorId: "current-user-id",
                content: textFieldText,
                seenByIds: nil,
                dateCreated: .now
            )
            chatMessages.append(message)
            textFieldText = ""
            scrollPosition = message.id
            
        } catch {
            showAlert = AnyAppAlert(error: error)
        }
    }
    
    private func showConfirmationDialog() {
        showConfirmation = AnyAppAlert(
            title: "",
            subtitle: "What would you like to do",
            showButtons: {
                AnyView(
                    VStack {
                        Button("Report User / Chat", role: .destructive) {
                            showConfirmation = nil
                            // Handle report action
                        }
                        Button("Delete Chat", role: .destructive) {
                            showConfirmation = nil
                            // Handle delete action
                        }
                        Button("Cancel", role: .cancel) {
                            showConfirmation = nil
                        }
                    }
                )
            }
        )
    }
    
    private func showProfileModalScreen() {
        showProfileModal = true
    }
    
    private func hideProfileModalScreen() {
        showProfileModal = false
    }
}

#Preview {
    NavigationStack {
        ChatDetailsView()
    }
}
