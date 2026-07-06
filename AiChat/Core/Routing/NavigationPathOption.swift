//
//  NavigationOption.swift
//  AiChat
//
//  Created by Sathya Kumar on 23/06/26.
//

import SwiftUI
enum NavigationPathOption: Hashable {
    case chat(avatarId: String, chat: ChatModal?)
    case category(category: CharecterOption, imageName: String)
}

extension View {
    func navigationDestinationForModule(path: Binding<[NavigationPathOption]>) -> some View {
        self
            .navigationDestination(for: NavigationPathOption.self) { option in
                switch option {
                case .chat(avatarId: let avatarId, chat: let chat):
                    ChatDetailsView(avatarId: avatarId, chat: chat)
                case .category(category: let category, let imageName):
                    CategoryListView(category: category, imageName: imageName, path: path)
                }
            }
    }
}
