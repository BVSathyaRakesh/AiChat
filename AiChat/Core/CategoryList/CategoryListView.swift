//
//  CategoryListView.swift
//  AiChat
//
//  Created by Sathya Kumar on 23/06/26.
//

import SwiftUI

struct CategoryListView: View {

    @Environment(AvatarManager.self) private var avatarManager
    var category: CharecterOption  = .alien
    var imageName: String = Constants.randomImage
    @State private var avatars: [AvatarModal] = []
    @Binding var path: [NavigationPathOption]
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        List {
            CategoryCellView(
                title: category.plural.capitalized,
                imageName: imageName,
                font: .largeTitle,
                cornerRadius: 0
            )
            .listRowSeparator(.hidden)
            .removeListRowFormatting()

            if let errorMessage {
                EmptyStateView(
                    title: "Error",
                    message: errorMessage,
                    buttonTitle: "Try again"
                ) {
                    retryLoadData()
                }
                .listRowSeparator(.hidden)
                .removeListRowFormatting()
            } else if isLoading {
                ProgressView()
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                    .removeListRowFormatting()
            } else if avatars.isEmpty {
                EmptyStateView(
                    title: "No Avatars",
                    message: "There are no avatars in this category yet."
                )
                .listRowSeparator(.hidden)
                .removeListRowFormatting()
            } else {
                ForEach(avatars, id: \.self) { avatar in
                    CustomListsCellView(
                        title: avatar.name,
                        subtitle: avatar.charecterDescription,
                        imageName: avatar.profileImageName
                    )
                    .listRowSeparator(.hidden)
                    .removeListRowFormatting()
                    .anyButton(.highlight) {
                        onAvatarPressed(avatar: avatar)
                    }
                }
               
            }
        }
        .ignoresSafeArea()
        .listStyle(.plain)
        .navigationTitle(category.plural.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadData()
        }
    }

    private func loadData() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
           avatars = try await avatarManager.getAvatarForCategory(catergory: category)
        } catch {
            errorMessage = "Please check your internet connection\nand try again."
            print("Error fetching avatars:\(error)")
        }

        isLoading = false
    }

    private func retryLoadData() {
        Task {
            await loadData()
        }
    }

    private func onAvatarPressed(avatar: AvatarModal) {
        path.append(.chat(avatarId: avatar.avatarId, chat: nil))
    }
}

#Preview("Loaded - With Data") {
    NavigationStack {
        CategoryListView(path: .constant([]))
    }
    .previewEnvironment(delay: 0.5)
}

#Preview("Error - No Connection") {
    NavigationStack {
        CategoryListView(path: .constant([]))
    }
    .previewEnvironment(shouldFail: true, delay: 1.0)
}

#Preview("Empty - No Data") {
    NavigationStack {
        CategoryListView(path: .constant([]))
    }
    .previewEnvironment(isEmpty: true, delay: 0.5)
}
