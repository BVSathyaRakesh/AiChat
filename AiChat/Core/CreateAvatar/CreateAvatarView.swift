//
//  CreateAvatarView.swift
//  AiChat
//
//  Created by Sathya Kumar on 21/06/26.
//

import SwiftUI

struct CreateAvatarView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AIManager.self) private var aiManager
    @Environment(AuthManager.self) private var authManager
    @Environment(AvatarManager.self) private var avatarManager
    @State private var avatarName: String = ""
    @State private var selectedCharacter: CharecterOption = .default
    @State private var selectedAction: CharecterAction = .default
    @State private var selectedLocation: CharcterLocation = .default
    @State private var generatedImageURL: String?
    @State private var isGeneratingImage: Bool = false
    @State private var showAlert: AnyAppAlert?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    nameTextField

                    VStack(spacing: 12) {
                        characterPicker
                        actionPicker
                        locationPicker
                    }

                    HStack(alignment: .top, spacing: 16 ) {
                            generateImageButton
                                .underline()
                      
                        avatarImageView
                    }

                    Spacer(minLength: 20)

                    saveButton
                }
                .padding(24)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Create Avatar")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.red)
                            .font(.title3)
                    }
                }
            }
            .showCustomAlert(alert: $showAlert)
        }
    }

    private var nameTextField: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("NAME YOUR AVATAR*")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(avatarName.count) / 30")
                    .font(.caption2)
                    .foregroundStyle(avatarName.count > 30 ? .red : (avatarName.count > 3 ? .green : .secondary))
            }

            TextField("Enter avatar name (3-30 characters)", text: $avatarName)
                .padding()
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            avatarName.count > 30 ? Color.red.opacity(0.5) :
                            avatarName.count > 3 ? Color.green.opacity(0.3) :
                            Color.clear,
                            lineWidth: 1
                        )
                )
                .onChange(of: avatarName) { _, newValue in
                    // Limit to 30 characters
                    if newValue.count > 30 {
                        avatarName = String(newValue.prefix(30))
                    }
                }
        }
    }

    private var characterPicker: some View {
        HStack {
            Text("is a...")
                .foregroundStyle(.primary)

            Spacer()

            Menu {
                Picker("Character", selection: $selectedCharacter) {
                    ForEach(CharecterOption.allCases, id: \.self) { option in
                        Text(option.rawValue.capitalized)
                            .tag(option)
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selectedCharacter.rawValue.capitalized)
                        .foregroundStyle(.secondary)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
    }

    private var actionPicker: some View {
        HStack {
            Text("that is...")
                .foregroundStyle(.primary)

            Spacer()

            Menu {
                Picker("Action", selection: $selectedAction) {
                    ForEach(CharecterAction.allCases, id: \.self) { action in
                        Text(action.rawValue.capitalized)
                            .tag(action)
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selectedAction.rawValue.capitalized)
                        .foregroundStyle(.secondary)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
    }

    private var locationPicker: some View {
        HStack {
            Text("in the...")
                .foregroundStyle(.primary)

            Spacer()

            Menu {
                Picker("Location", selection: $selectedLocation) {
                    ForEach(CharcterLocation.allCases, id: \.self) { location in
                        Text(location.rawValue.capitalized)
                            .tag(location)
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selectedLocation.rawValue.capitalized)
                        .foregroundStyle(.secondary)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
    }

    private var generateImageButton: some View {
        ZStack {
            Text("Generate image")
                    .font(.body)
                    .foregroundStyle(.red)
                    .opacity(isGeneratingImage ? 0 : 1.0)
                    .anyButton {
                     isGeneratingImage = true
                      generateImage()
                    }
            ProgressView()
                .tint(.accent)
                .opacity(isGeneratingImage ? 1.0 : 0)
        }
        .disabled(isGeneratingImage || avatarName.isEmpty)
        
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var avatarImageView: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 200, height: 200)

            if let imageURL = generatedImageURL {
                ImageLoaderView(urlString: imageURL)
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.gray.opacity(0.5))

                    Text("No image")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private var saveButton: some View {
        AsyncActionButton(title: "Save") {
            await saveAvatar()
        }
        .opacity(generatedImageURL == nil ? 0.5 : 1.0)
        .disabled(generatedImageURL == nil)
    }

    private func generateImage() {
        // Generate AI image based on selected options
        Task {
            do {
                let prompt = AvatarDescriptionBuilder(
                    charecterOption: selectedCharacter,
                    charecterAction: selectedAction,
                    charceterLocation: selectedLocation
                ).charcterDescription

                print("Generating image with prompt: \(prompt)")
                generatedImageURL = try await aiManager.generateImage(input: prompt)
                print("Generated image URL: \(generatedImageURL ?? "nil")")
            } catch {
                showAlert = AnyAppAlert(
                    title: "Image Generation Failed",
                    subtitle: "Unable to generate avatar image. Please try again.",
                    showButtons: {
                        AnyView(
                            Button("OK", role: .cancel) { }
                        )
                    }
                )
                print("Error generating image: \(error)")
            }
            isGeneratingImage = false
        }
    }

    fileprivate func performAvatarAction() async throws {
        try TextValidationHelper.validateTextField(text: avatarName)
        
        let uid = try authManager.getAuthId()
        
        let avatar = AvatarModal(
            avatarId: UUID().uuidString,
            name: avatarName,
            charcterOption: selectedCharacter,
            charcterAction: selectedAction,
            charcetrLocation: selectedLocation,
            profileImageName: generatedImageURL,
            authorId: uid,
            dateCreated: .now
        )
        
        // Save avatar to Firestore
        try await avatarManager.saveAvatarData(avatarModel: avatar)
        
        print("✅ Avatar saved successfully!")
        print("Avatar ID: \(avatar.avatarId)")
        print("Image URL: \(generatedImageURL ?? "nil")")
        
        // Clear all values
        avatarName = ""
        selectedCharacter = .default
        selectedAction = .default
        selectedLocation = .default
        generatedImageURL = nil
        isGeneratingImage = false
        
        dismiss()
    }
    
    private func saveAvatar() async {
        print("Saving avatar: \(avatarName)")

        do {
            try await performAvatarAction()
        } catch {
            // Show error alert using custom alert system
            showAlert = AnyAppAlert(error: error)
            print("❌ Error saving avatar: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CreateAvatarView()
        .environment(AIManager(aiService: MockAIService()))
        .environment(AuthManager(authService: MockAuthService(user: .mock())))
        .environment(AvatarManager(service: MockAvatarService()))
}
