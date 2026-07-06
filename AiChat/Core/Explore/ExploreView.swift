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
    @State var categoryAvatars: [AvatarModal] = []
    @State var popularAvatars: [AvatarModal] = []
    @State var path: [NavigationPathOption] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
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
                        .listRowSeparator(.hidden)
                        .frame(maxWidth: .infinity)
                        .removeListRowFormatting()
                } else {
                    if !featuredAvatars.isEmpty {
                        featuredSection
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    if !categoryAvatars.isEmpty {
                        categoriesSection
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    if !popularAvatars.isEmpty {
                        popularSection
                    }
                    if featuredAvatars.isEmpty && categoryAvatars.isEmpty && popularAvatars.isEmpty {
                        EmptyStateView(
                            title: "No Avatars",
                            message: "There are no avatars available at the moment."
                        )
                        .listRowSeparator(.hidden)
                        .removeListRowFormatting()
                    }
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
            await loadAllData()
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
                            let imageName = categoryAvatars.last(where: { $0.charcterOption == item})?.profileImageName
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
        path.append(.chat(avatarId: avatar.avatarId, chat: nil))
    }
    
    private func onCategoryPressed(category: CharecterOption, imageName: String) {
        path.append(.category(category: category, imageName: imageName))
    }
    
    private func loadAllData() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            async let featured = avatarManager.fetchFeaturedAvatars(limit: 5)
            async let category = avatarManager.fetchAllAvatars(limit: 200)
            async let popular = avatarManager.fetchPopularAvatars(limit: 5)

            featuredAvatars = try await featured
            categoryAvatars = try await category
            popularAvatars = try await popular
        } catch {
            errorMessage = "Please check your internet connection\nand try again."
            print("Error fetching avatars: \(error)")
        }

        isLoading = false
    }

    private func retryLoadData() {
        Task {
            await loadAllData()
        }
    }
}

#Preview("Loaded - With Data") {
    ExploreView()
        .previewEnvironment(delay: 0.5)
}

#Preview("Error - No Connection") {
    ExploreView()
        .previewEnvironment(shouldFail: true, delay: 1.0)
}

#Preview("Empty - No Data") {
    ExploreView()
        .previewEnvironment(isEmpty: true, delay: 0.5)
}
