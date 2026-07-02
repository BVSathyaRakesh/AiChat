//
//  ExploreView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct ExploreView: View {
    
    @Environment(AvatarManager.self) private var avatarManager
    let avatar = AvatarModal.mock
    @State var featuredAvatars: [AvatarModal] = []
    @State var catergories: [CharecterOption] = CharecterOption.allCases
    @State var popularAvatars: [AvatarModal] = []
    @State var path: [NavigationPathOption] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if featuredAvatars.isEmpty && popularAvatars.isEmpty {
                    ProgressView()
                        .padding(20)
                        .listRowSeparator(.hidden)
                        .frame(maxWidth: .infinity)
                        .removeListRowFormatting()
                }
                if !featuredAvatars.isEmpty {
                    featuredSection
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                if !popularAvatars.isEmpty {
                    categoriesSection
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    popularSection
                }
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
        .task {
            await featuredAvatars()
        }
        .task {
            await popularAvatars()
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
                        onAVatarPressed(avatar: avatar)
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
                                    title: item.plural.capitalized,
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
                        onCategoryPressed(category: avatar.charcterOption ?? .alien, imageName: avatar.profileImageName ?? Constants.randomImage)
                        
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
    
    private func featuredAvatars() async {
        guard featuredAvatars.isEmpty else { return }
        do {
           featuredAvatars = try await avatarManager.fetchFeaturedAvatars(limit: 5)
        } catch {
            print("Error fetching avatars: \(error)")
        }
    }

    private func popularAvatars() async {
        guard popularAvatars.isEmpty else { return }
        do {
           popularAvatars = try await avatarManager.fetchPopularAvatars(limit: 5)
        } catch {
            print("Error fetching avatars: \(error)")
        }
    }
}

#Preview {
    ExploreView()
        .environment(AvatarManager(service: MockAvatarService()))
}
