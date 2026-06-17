//
//  ExploreView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct ExploreView: View {
    
    let avatar = AvatarModal.mock
    
    var body: some View {
        NavigationStack {
            HeroCellView(
                title: avatar.name,
                subtitle: avatar.charecterDescription,
                image: avatar.profileImageName
            )
            .frame( height: 200)
            .navigationTitle("Explore")
        }
    }
}

#Preview {
    ExploreView()
}
