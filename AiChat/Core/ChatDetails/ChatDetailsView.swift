//
//  ChatDetailsView.swift
//  AiChat
//
//  Created by Sathya Kumar on 22/06/26.
//

import SwiftUI

struct ChatDetailsView: View {

    @Environment(AvatarManager.self) private var avatarManager
    @Environment(AIManager.self) private var aiManager
    @State private var chatMessages: [ChatMessageModal]
    @State private var avatarmodel: AvatarModal? = AvatarModal.mock
    @State private var textFieldText: String = ""
    @State private var scrollPosition: String?
    @State private var showAlert: AnyAppAlert?
    @State private var showConfirmation: AnyAppAlert?
    @State private var showProfileModal: Bool = false
    @State private var isSendingMessage = false
    var avatarId: String = AvatarModal.mock.avatarId

    init(avatarId: String = AvatarModal.mock.avatarId, initialMessages: [ChatMessageModal] = []) {
        self.avatarId = avatarId
        self._chatMessages = State(initialValue: initialMessages)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            scrollViewSection
            textFieldSection
        }
        .onAppear {
            UIScrollView.appearance().delaysContentTouches = false
        }
        .task {
           await loadAvtar()
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
                    .showCustomAlert(type: .confirmationDialog, alert: $showConfirmation)
                    .disabled(showProfileModal)
            }
        }
        .navigationBarBackButtonHidden(showProfileModal)
        .showCustomAlert(alert: $showAlert)
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
            .disabled(isSendingMessage)
            .padding(12)
            .padding(.trailing, 60)
            .overlay(
                Image(systemName: isSendingMessage ? "ellipsis.circle.fill" : "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .padding(.trailing, 4)
                    .foregroundStyle(isSendingMessage ? .gray : .accent)
                    .symbolEffect(.pulse, isActive: isSendingMessage)
                    .anyButton {
                       sendMessage()
                    }
                    .disabled(isSendingMessage)
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
        guard !isSendingMessage else { return }

        Task {
            isSendingMessage = true
            defer { isSendingMessage = false }

            do {
                try TextValidationHelper.validateTextField(text: textFieldText)

                // Save the message text before clearing
                let userMessage = textFieldText

                // Add user message immediately and clear text field
                sendMessageText(userMessage)

                // Build conversation history
                let conversationHistory = buildConversationHistory()

                // Generate AI response with context
                let systemPrompt = buildSystemPrompt()
                let aiResponse = try await aiManager.generateTextWithContext(
                    messages: conversationHistory,
                    systemPrompt: systemPrompt
                )

                // Add AI response
                try await Task.sleep(for: .seconds(0.5))
                getAiResponse(response: aiResponse)

            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
    }

    private func buildConversationHistory() -> [AIChatModel] {
        // Get last 10 messages for context
        let recentMessages = chatMessages.suffix(10)
        return recentMessages.compactMap { $0.content }
    }

    private func buildSystemPrompt() -> String {
        guard let avatar = avatarmodel else {
            return "You are a helpful AI assistant. Be friendly and conversational."
        }

        return """
        You are \(avatar.name ?? "an AI character"). \(avatar.charecterDescription)

        Respond in character, staying true to your personality and background.
        Be engaging, friendly, and conversational.
        Keep responses concise and natural.
        """
    }
    
    private func sendMessageText(_ text: String) {
        let message = ChatMessageModal(
            id: UUID().uuidString,
            chatId: UUID().uuidString,
            authorId: "current-user-id",
            content: .user(text),
            seenByIds: nil,
            dateCreated: .now
        )
        chatMessages.append(message)
        textFieldText = ""
        scrollPosition = message.id
    }
    
    private func getAiResponse(response: String) {
        let messageReply = ChatMessageModal(
            id: UUID().uuidString,
            chatId: UUID().uuidString,
            authorId: avatarId,
            content: .assistant(response),
            seenByIds: nil,
            dateCreated: .now
        )
        chatMessages.append(messageReply)
        scrollPosition = messageReply.id
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
    
    fileprivate func loadAvtar() async {
        do {
            avatarmodel = try await avatarManager.getAvatarById(avatarId: avatarId)
            if let avatarmodel {
                try?  await avatarManager.addRecentAvatar(avatarModel: avatarmodel)
            }
        } catch {
            print("Error loading avatar: \(error)")
        }
    }
}

#Preview("With Messages") {
    NavigationStack {
        ChatDetailsView(initialMessages: ChatMessageModal.mocks)
            .previewEnvironment()
    }
}

#Preview("Empty Chat - No Data") {
    NavigationStack {
        ChatDetailsView(initialMessages: [])
            .previewEnvironment()
    }
}
