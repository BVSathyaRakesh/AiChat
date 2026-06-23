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
    @State var popularAvatars: [AvatarModal] = AvatarModal.mocks
    @State var path: [NavigationPathOption] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                featuredSection
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                categoriesSection
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                popularSection
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Explore")
            .onAppear {
                UIScrollView.appearance().delaysContentTouches = false
            }
            .navigationDestinationForModule(path: $path)

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
                    .anyButton {
                        onCategoryPressed(category: avatar.charcterOption ?? .alien, imageName: avatar.profileImageName ?? Constants.randomImage)
                    }
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
                            let imageName = popularAvatars.first(where: { $0.charcterOption == item})?.profileImageName
                            if let imageName {
                                CategoryCellView(
                                    title: item.rawValue.capitalized,
                                    imageName: imageName
                                )
                                .anyButton {
                                    onCategoryPressed(category: item, imageName: imageName)
                                }
                            }
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
    
    private var popularSection: some View {
        Section {
            VStack(spacing: 0) {
                ForEach(Array(popularAvatars.enumerated()), id: \.element) { index, avatar in
                    CustomListsCellView(
                        title: avatar.name,
                        subtitle: avatar.charecterDescription,
                        imageName: avatar.profileImageName
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .anyButton(.highlight) {
                        onAVatarPressed(avatar: avatar)
                    }
                    if index < popularAvatars.count - 1 {
                        Divider()
                            .padding(.leading, 84)
                    }
                 }
            }
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(16)
            .padding(.horizontal, 8)
        } header: {
            Text("Popular")
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
    
    private func onAVatarPressed(avatar: AvatarModal) {
        path.append(.chat(avatarId: avatar.avatarId))
    }
    
    private func onCategoryPressed(category: CharecterOption, imageName: String) {
        path.append(.category(category: category, imageName: imageName))
    }
}

#Preview {
    ExploreView()
}
