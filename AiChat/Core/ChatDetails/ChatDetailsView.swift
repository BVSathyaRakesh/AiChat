//
//  ChatDetailsView.swift
//  AiChat
//
//  Created by Sathya Kumar on 22/06/26.
//

import SwiftUI

extension View {
    func showCustomAlert(alert: Binding<AnyAppAlert?>) -> some View {
        self
            .alert(alert.wrappedValue?.title ?? "", isPresented: Binding(ifNotNil: alert), actions: {
                alert.wrappedValue?.showButtons()
            }, message: {
                if let subtitle = alert.wrappedValue?.subtitle {
                    Text(subtitle)
                }
            })
    }
}

struct ChatDetailsView: View {
    
    @State private var chatMessages: [ChatMessageModal] = ChatMessageModal.mocks
    @State private var avatarmodel: AvatarModal? = AvatarModal.mock
    @State private var textFieldText: String = ""
    @State private var showChatSettings: Bool = false
    @State private var scrollPosition: String?
    @State private var showAlert: AnyAppAlert?
    
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
                        showChatSettings.toggle()
                    }
            }
        }
        .showCustomAlert(alert: $showAlert)
        .sheet(isPresented: $showChatSettings) {
            VStack(spacing: 20) {
                Text("What would you like to do")
                    .font(.headline)
                    .padding(.top)
                sheetButton(title: "Report User / Chat", role: .destructive) {
                    showChatSettings = false
                }

                sheetButton(title: "Delete Chat", role: .destructive) {
                    showChatSettings = false
                }

                sheetButton(title: "Cancel", role: .destructive) {
                    showChatSettings = false
                }
            }
            .padding()
            .presentationDetents([.height(300)])
            .presentationDragIndicator(.visible)
        }
    }
    
    private var scrollViewSection: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(chatMessages) { message in
                    ChatBubbleViewBuilder(
                        message: message,
                        isCurrentuser: message.isFromCurrentUser,
                        imageName: message.isFromCurrentUser ? nil : avatarmodel?.profileImageName
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

    private func sheetButton(title: String, role: ButtonRole?, action: @escaping () -> Void) -> some View {
        Button(role: role) {
            action()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(role == .destructive ? Color.red.opacity(0.1) : Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
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
}

#Preview {
    NavigationStack {
        ChatDetailsView()
    }
}
