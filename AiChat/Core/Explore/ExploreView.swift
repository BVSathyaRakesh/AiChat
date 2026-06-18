//
//  ExploreView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct ExploreView: View {
    
    let avatar = AvatarModal.mock
    @State var featuredAvatars: [AvatarModal] = AvatarModal.mocks
    @State var catergories: [CharecterOption] = CharecterOption.allCases
    
    var body: some View {
        NavigationStack {
            List {
                featuredSection
                    .listRowSeparator(.hidden)
                categoriesSection
                    .listRowSeparator(.hidden)
                
            }
            .listStyle(.plain)
            .padding(.horizontal, 2)
            .navigationTitle("Explore")
            
        }
    }
    
    private var featuredSection: some View {
        Section {
            ZStack {
                CorouselView(items: featuredAvatars) { avatar in
                    HeroCellView(
                        title: avatar.name,
                        subtitle: avatar.charecterDescription,
                        image: avatar.profileImageName
                    )
                }
            }
        } header: {
            Text("Featured Avatars")
        }
    }
    
    private var categoriesSection: some View {
        Section {
            ZStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(catergories, id: \.self) { item in
                            CategoryCellView(
                                title: item.rawValue.capitalized,
                                imageName: Constants.randomImage
                            )
                        }
                    }
                }
                .frame(height: 140)
                .scrollIndicators(.hidden)
                .scrollTargetLayout()
                .scrollTargetBehavior(.viewAligned)
            }
            
        } header: {
            Text("Categoreis")
        }
    }
}

#Preview {
    ExploreView()
}
