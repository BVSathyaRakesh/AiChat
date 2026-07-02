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

    var body: some View {
        List {
            CategoryCellView(
                title: category.plural.capitalized,
                imageName: imageName,
                font: .largeTitle,
                cornerRadius: 0
            )
            .removeListRowFormatting()
            ForEach(avatars, id: \.self) { avatar in
                CustomListsCellView(
                    title: avatar.name,
                    subtitle: avatar.charecterDescription,
                    imageName: avatar.profileImageName
                )
                .removeListRowFormatting()
                .anyButton(.highlight) {
                    onAvatarPressed(avatar: avatar)
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
        do {
           avatars = try await avatarManager.getAvatarForCategory(catergory: category)
        } catch {
            print("Error fetching avatars:\(error)")
        }
    }
    private func onAvatarPressed(avatar: AvatarModal) {
        path.append(.chat(avatarId: avatar.avatarId))
    }
}

#Preview {
    NavigationStack {
        CategoryListView(path: .constant([]))
            .environment(AvatarManager(service: MockAvatarService()))
    }
}
