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
    @State private var chatMessages: [ChatMessageModal]
    @State private var chat: ChatModal?
    @State private var avatarmodel: AvatarModal? = AvatarModal.mock
    @State private var textFieldText: String = ""
    @State private var scrollPosition: String?
    @State private var showAlert: AnyAppAlert?
    @State private var showConfirmation: AnyAppAlert?
    @State private var showProfileModal: Bool = false
    @State private var isSendingMessage = false
    @State private var currentuser: UserModel?
    @State private var messageListener: ListenerRegistration?
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
                    let isCurrentUser = (try? authManager.getAuthId()) == message.authorId
                    ChatBubbleViewBuilder(
                        message: message,
                        isCurrentuser: isCurrentUser,
                        imageName: isCurrentUser ? nil : avatarmodel?.profileImageName,
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

                // upload user chat
                try await chatManager.addChatMessage(chatId: chat.id, message: message)
                // clear textfield (listener will update UI and scroll)
                textFieldText = ""

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

                // Generate AI response (without character personality)
                let aiResponse = try await aiManager.generateTextWithContext(
                    messages: conversationHistory,
                    systemPrompt: buildSystemPrompt()
                )

                // Remove typing indicator
                chatMessages.removeAll(where: { $0.id == "thinking-indicator" })

                // Add actual AI response
                let aiMessage = ChatMessageModal.createAssistantMessage(chatId: chat.id, authorId: avatarId, text: aiResponse)
                // upload Ai chat (listener will update UI and scroll)
                try await chatManager.addChatMessage(chatId: chat.id, message: aiMessage)

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

    private func loadChatData() async {
        do {
            // Get current user ID
            let userId = try authManager.getAuthId()

            // Build chat ID based on the pattern: userId_avatarId
            let chatId = "\(userId)_\(avatarId)"

            // Try to fetch existing chat
            chat = try await chatManager.getChat(chatId: chatId)

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

#Preview("AI Generating Response") {
    struct PreviewWrapper: View {
        @State private var messages: [ChatMessageModal]

        init() {
            let mockUserId = UserAuthInfo.mock().uid
            let mockAvatarId = AvatarModal.mock.avatarId
            let chatId = "\(mockUserId)_\(mockAvatarId)"

            _messages = State(initialValue: [
                ChatMessageModal(
                    id: UUID().uuidString,
                    chatId: chatId,
                    authorId: mockUserId,
                    content: .user("Hey! How are you doing today?"),
                    seenByIds: [mockAvatarId],
                    dateCreated: Date().addingTimeInterval(-60 * 15)
                ),
                ChatMessageModal(
                    id: UUID().uuidString,
                    chatId: chatId,
                    authorId: mockAvatarId,
                    content: .assistant("Hello! I'm doing great, thank you for asking. How about you?"),
                    seenByIds: [mockUserId],
                    dateCreated: Date().addingTimeInterval(-60 * 14)
                ),
                ChatMessageModal(
                    id: UUID().uuidString,
                    chatId: chatId,
                    authorId: mockUserId,
                    content: .user("Can you tell me about your features?"),
                    seenByIds: [],
                    dateCreated: Date().addingTimeInterval(-5)
                ),
                // Placeholder "thinking" message
                ChatMessageModal(
                    id: "thinking-placeholder",
                    chatId: chatId,
                    authorId: mockAvatarId,
                    content: .assistant("..."),
                    seenByIds: [],
                    dateCreated: .now
                )
            ])
        }

        var body: some View {
            NavigationStack {
                ChatDetailsView(initialMessages: messages)
                    .previewEnvironment()
                    .task {
                        // Simulate AI generating for 2 seconds
                        try? await Task.sleep(for: .seconds(2))

                        // Replace placeholder with actual response
                        if let index = messages.firstIndex(where: { $0.id == "thinking-placeholder" }) {
                            let mockUserId = UserAuthInfo.mock().uid
                            let mockAvatarId = AvatarModal.mock.avatarId
                            let chatId = "\(mockUserId)_\(mockAvatarId)"

                            messages[index] = ChatMessageModal(
                                id: UUID().uuidString,
                                chatId: chatId,
                                authorId: mockAvatarId,
                                content: .assistant("I'd be happy to tell you about the features! You can chat with AI characters, create custom avatars, and have engaging conversations on various topics."),
                                seenByIds: [],
                                dateCreated: .now
                            )
                        }
                    }
            }
        }
    }

    return PreviewWrapper()
}
