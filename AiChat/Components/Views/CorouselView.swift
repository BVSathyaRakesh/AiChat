//
//  CorouselView.swift
//  AiChat
//
//  Created by Sathya Kumar on 18/06/26.
//

import SwiftUI

struct CorouselView<Content: View, T: Hashable>: View {
    
    var items: [T]
    @ViewBuilder var content: (T) -> Content
    @State private var selection: T?
    
    var body: some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal) {
               corouselItem
            }
            .frame(height: 200)
            .scrollIndicators(.hidden)
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $selection)
            .onChange( of: items.count, { _, _ in
                updateSelectionIfNeeded()
            })
            .onAppear {
                updateSelectionIfNeeded()
            }
            selectionIndicators
            .animation(.interactiveSpring, value: selection)
        }
    }
    
    private var corouselItem: some View {
        LazyHStack(spacing: 0) {
            ForEach(items, id: \.self) { item in
               content(item)
                .scrollTransition(.interactive.threshold(.visible(0.95)), transition: { content, phase in
                    content
                        .scaleEffect(phase.isIdentity ? 1: 0.9)
                })
                .containerRelativeFrame(.horizontal, alignment: .center)
                .id(item)
            }
        }
    }
    
    private var selectionIndicators: some View {
        HStack(spacing: 8) {
            ForEach(items, id: \.self) { item in
                Circle()
                    .fill(selection == item ? .accent : .secondary.opacity(0.5))
                    .frame(width: 8, height: 8)
            }
        }
    }
    
    private func updateSelectionIfNeeded() {
        if selection == nil || selection == items.last {
            selection = items.first
        }
    }
}

#Preview {
    CorouselView(items: AvatarModal.mocks) { item in
        HeroCellView(
            title: item.name,
            subtitle: item.charecterDescription,
            image: item.profileImageName
        )
    }
    .padding()
}
