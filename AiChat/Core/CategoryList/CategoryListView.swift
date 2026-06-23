//
//  CategoryListView.swift
//  AiChat
//
//  Created by Sathya Kumar on 23/06/26.
//

import SwiftUI

struct CategoryListView: View {
    
    private var category: CharecterOption  = .alien
    var imageName: String = Constants.randomImage
    @State private var avatars: [AvatarModal] = AvatarModal.mocks
    
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
            }
        }
        .ignoresSafeArea()
        .listStyle(.plain)
    }
}

#Preview {
    CategoryListView()
}
