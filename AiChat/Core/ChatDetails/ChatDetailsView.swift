//
//  ChatDetailsView.swift
//  AiChat
//
//  Created by Sathya Kumar on 22/06/26.
//

import SwiftUI
import FirebaseFirestore

struct ChatDetailsView: View {

    @Environment(AvatarManager.self) private var avatarManager
    @Environment(AIManager.self) private var aiManager
    @Environment(AuthManager.self) private var authManager
    @Environment(ChatManager.self) private var chatManager
    @Environment(\.dismiss) private var dismiss
    @State private var chatMessages: [ChatMessageModal] = []
    @State private var avatarmodel: AvatarModal? = AvatarModal.mock
    @State private var textFieldText: String = ""
    @State private var scrollPosition: String?
    @State private var showAlert: AnyAppAlert?
    @State private var showConfirmation: AnyAppAlert?
    @State private var showProfileModal: Bool = false
    @State private var isSendingMessage = false
    @State private var isClearingMessages = false
    @State private var isReporting = false
    @State private var currentuser: UserModel?
    @State private var messageListener: ListenerRegistration?
    @State private var chat: ChatModal?
    @State private var isPreviewMode = false
    var avatarId: String = AvatarModal.mock.avatarId

    init(avatarId: String = AvatarModal.mock.avatarId, chat: ChatModal? = nil, initialMessages: [ChatMessageModal] = [], isPreview: Bool = false) {
        self.avatarId = avatarId
        self._chat = State(initialValue: chat)
        self._chatMessages = State(initialValue: initialMessages)
        self._isPreviewMode = State(initialValue: isPreview)
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
        .task {
            await loadChatData()
        }
        .onDisappear {
            messageListener?.remove()
            messageListener = nil
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
                    .disabled(showProfileModal || isClearingMessages || isReporting)
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
        .overlay {
            if isClearingMessages || isReporting {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text(isClearingMessages ? "Clearing messages..." : "Reporting chat...")
                            .foregroundStyle(.white)
                            .font(.headline)
                    }
                    .padding(32)
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(16)
                }
            }
        }
    }
    
    private var scrollViewSection: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                ForEach(Array(chatMessages.enumerated()), id: \.element.id) { index, message in
                    let isCurrentUser = (try? authManager.getAuthId()) == message.authorId
                    let shouldShowTimestamp = shouldShowTimestamp(for: message, at: index)

                    VStack(spacing: 4) {
                        if shouldShowTimestamp {
                            Text(formatTimestamp(message.dateCreated))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
                                .padding(.vertical, 4)
                        }

                        ChatBubbleViewBuilder(
                            message: message,
                            isCurrentuser: isCurrentUser,
                            imageName: isCurrentUser ? nil : avatarmodel?.profileImageName,
                            action: showProfileModalScreen
                        )
                    }
                    .id(message.id)
                    .onAppear {
                        markMessageAsSeenIfNeeded(message: message, isCurrentUser: isCurrentUser)
                    }
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
            .disabled(isSendingMessage || isClearingMessages || isReporting)
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
                    .disabled(isSendingMessage || isClearingMessages || isReporting)
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

    private  func sendMessage() {
        guard !isSendingMessage else { return }

        Task {
            isSendingMessage = true
            defer { isSendingMessage = false }

            do {
                // validate the textfield
                try TextValidationHelper.validateTextField(text: textFieldText)
                // get the current user id
                let userId = try authManager.getAuthId()
                
                // If chat is nil  create a new chat
                if chat == nil {
                    // craete a new chat
                   chat = try await createNewChat(uid: userId)

                   // Start listening for real-time updates on the new chat
                   if let newChat = chat {
                       startMessageListener(chatId: newChat.id)
                   }
                }

                // If chat is nil, throw error should never happen
                guard let chat  else {
                    throw ChatError.noChatFound
                }

                // Save the message text before clearing
                let userMessage = textFieldText

                // Add user message immediately and clear text field
                let message = ChatMessageModal.createUserMessage(chatId: chat.id, authorId: userId, text: userMessage)

                // Show message immediately (optimistic update)
                chatMessages.append(message)
                scrollPosition = message.id
                textFieldText = ""

                // Upload user chat to Firebase in background
                Task {
                    try? await chatManager.addChatMessage(chatId: chat.id, message: message)
                }

                // Build conversation history
                let conversationHistory = buildConversationHistory()

                // Add typing indicator bubble
                let thinkingMessage = ChatMessageModal(
                    id: "thinking-indicator",
                    chatId: chat.id,
                    authorId: avatarId,
                    content: .assistant("..."),
                    seenByIds: nil,
                    dateCreated: .now
                )
                chatMessages.append(thinkingMessage)
                scrollPosition = thinkingMessage.id

                // Generate AI response
                let aiResponse = try await aiManager.generateTextWithContext(
                    messages: conversationHistory,
                    systemPrompt: nil
                )

                // Remove typing indicator
                chatMessages.removeAll(where: { $0.id == "thinking-indicator" })

                // Add actual AI response
                let aiMessage = ChatMessageModal.createAssistantMessage(chatId: chat.id, authorId: avatarId, text: aiResponse)
                chatMessages.append(aiMessage)
                scrollPosition = aiMessage.id

                // Upload AI chat to Firebase in background
                Task {
                    try? await chatManager.addChatMessage(chatId: chat.id, message: aiMessage)
                }

            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
    }
    
    enum ChatError: Error {
       case noChatFound
    }

    private func createNewChat(uid: String) async throws -> ChatModal {
        let newChat = ChatModal.new(userId: uid, avatarId: avatarId)
        try await chatManager.createNewChat(chat: newChat)
        return newChat
    }

    private func startMessageListener(chatId: String) {
        // Remove any existing listener first
        messageListener?.remove()

        // Start listening for real-time updates
        messageListener = chatManager.observeChatMessages(chatId: chatId) { [self] updatedMessages in
            chatMessages = updatedMessages
            // Auto-scroll to latest message
            if let lastMessage = updatedMessages.last {
                scrollPosition = lastMessage.id
            }
        }
    }

    private func buildConversationHistory() -> [AIChatModel] {
        // Get last 10 messages for context
        let recentMessages = chatMessages.suffix(10)
        return recentMessages.compactMap { $0.content }
    }

    private func shouldShowTimestamp(for message: ChatMessageModal, at index: Int) -> Bool {
        // Always show for first message
        guard index > 0 else { return true }

        // Get previous message
        let previousMessage = chatMessages[index - 1]

        // Show timestamp if time difference is more than 5 minutes
        let timeDifference = message.dateCreated.timeIntervalSince(previousMessage.dateCreated)
        return timeDifference > 300 // 5 minutes in seconds
    }

    private func formatTimestamp(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInToday(date) {
            // Today: "Today 10:30 AM"
            let time = date.formatted(date: .omitted, time: .shortened)
            return "Today \(time)"
        } else if calendar.isDateInYesterday(date) {
            // Yesterday: "Yesterday 10:30 AM"
            let time = date.formatted(date: .omitted, time: .shortened)
            return "Yesterday \(time)"
        } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
            // This week: "Monday 10:30 AM"
            return date.formatted(.dateTime.weekday(.wide).hour().minute())
        } else {
            // Older: "Oct 7, 2023 10:30 AM"
            return date.formatted(date: .abbreviated, time: .shortened)
        }
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

    fileprivate func onDeleteClicked() {
        Task {
            guard let chat else { return }

            isClearingMessages = true
            defer { isClearingMessages = false }

            do {
                try await chatManager.deleteChatMessages(chatId: chat.id)
                // Navigate back to chats view after deletion
                dismiss()
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
        }
    }

    fileprivate func onReportClicked() {
        Task {
            guard let chat else { return }

            isReporting = true
            defer { isReporting = false }

            do {
                let userId = try authManager.getAuthId()
                try await chatManager.reportChat(chatId: chat.id, userId: userId)
                // Show success message
                showAlert = AnyAppAlert(title: "Reported", subtitle: "Thank you for reporting. We will review this chat.")
            } catch {
                showAlert = AnyAppAlert(error: error)
            }
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
                            onReportClicked()
                        }
                        Button("Clear Messages", role: .destructive) {
                            showConfirmation = nil
                            onDeleteClicked()
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

    private func loadChatData() async {
        // Skip loading in preview mode
        guard !isPreviewMode else { return }

        do {
            // Get current user ID
            let userId = try authManager.getAuthId()

            // Build chat ID based on the pattern: userId_avatarId
            let chatId = "\(userId)_\(avatarId)"

            // If chat is not already provided, try to fetch it
            if chat == nil {
                chat = try await chatManager.getChat(chatId: chatId)
            }

            // If chat exists, load messages and start listening
            if chat != nil {
                let messages = try await chatManager.getChatMessages(chatId: chatId)
                chatMessages = messages
                // Scroll to latest message
                if let lastMessage = messages.last {
                    scrollPosition = lastMessage.id
                }

                // Start listening for real-time updates
                startMessageListener(chatId: chatId)
            }
        } catch {
            print("Error loading chat data: \(error)")
        }
    }

    private func markMessageAsSeenIfNeeded(message: ChatMessageModal, isCurrentUser: Bool) {
        // Skip in preview mode
        guard !isPreviewMode else { return }

        // Only mark messages from other users (not current user's messages)
        guard !isCurrentUser else { return }

        // Skip if already seen by current user
        guard let userId = try? authManager.getAuthId(),
              !message.hasSeenBy(userId: userId),
              let chatId = chat?.id else { return }

        // Mark as seen in background
        Task {
            try? await chatManager.markMessageAsSeen(chatId: chatId, messageId: message.id, userId: userId)
        }
    }
}

#Preview("With Messages") {
    NavigationStack {
        ChatDetailsView(
            avatarId: AvatarModal.mock.avatarId,
            chat: ChatModal.mock,
            initialMessages: ChatMessageModal.previewConversation,
            isPreview: true
        )
        .previewEnvironment()
    }
}

#Preview("Empty Chat - No Data") {
    NavigationStack {
        ChatDetailsView(initialMessages: [], isPreview: true)
            .previewEnvironment()
    }
}

#Preview("AI Generating Response") {
    NavigationStack {
        ChatDetailsView(
            avatarId: AvatarModal.mock.avatarId,
            chat: ChatModal.mock,
            initialMessages: ChatMessageModal.previewAIGenerating,
            isPreview: true
        )
        .previewEnvironment()
    }
}
