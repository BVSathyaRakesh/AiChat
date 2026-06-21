//
//  CreateAvatarView.swift
//  AiChat
//
//  Created by Sathya Kumar on 21/06/26.
//

import SwiftUI

struct CreateAvatarView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var avatarName: String = ""
    @State private var selectedCharacter: CharecterOption = .default
    @State private var selectedAction: CharecterAction = .default
    @State private var selectedLocation: CharcterLocation = .default
    @State private var generatedImageURL: String?
    @State private var isGeneratingImage: Bool = false

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
        }
    }

    private var nameTextField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NAME YOUR AVATAR*")
                .font(.caption)
                .foregroundStyle(.secondary)

            TextField("", text: $avatarName)
                .padding()
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(12)
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
            try?  await Task.sleep(for: .seconds(2))
              generatedImageURL = Constants.randomImage
              print("Generate image: \(selectedCharacter.rawValue) \(selectedAction.rawValue) in \(selectedLocation.rawValue)")
              isGeneratingImage = false
        }
    }

    private func saveAvatar() async {
        // Save avatar logic
        print("Save avatar: \(avatarName)")
        try? await Task.sleep(for: .seconds(1))

        // Clear all values
        avatarName = ""
        selectedCharacter = .default
        selectedAction = .default
        selectedLocation = .default
        generatedImageURL = nil
        isGeneratingImage = false

        dismiss()
    }
}

#Preview {
    CreateAvatarView()
}
