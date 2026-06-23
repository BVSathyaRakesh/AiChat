//
//  CustomModalView.swift
//  AiChat
//
//  Created by Sathya Kumar on 23/06/26.
//

import SwiftUI

struct CustomModalView<Content: View>: View {

    @Binding var isPresented: Bool
    var overlayColor: Color = .black
    var overlayOpacity: Double = 0.6
    var contentPadding: CGFloat = 40
    var transition: AnyTransition = .slide
    var animation: Animation = .bouncy
    var onDismiss: (() -> Void)?
    @ViewBuilder var content: () -> Content

    var body: some View {
        if isPresented {
            ZStack {
                overlayColor.opacity(overlayOpacity)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(.all)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismissModal()
                    }

                content()
                    .padding(contentPadding)
                    .transition(transition)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .transition(.opacity)
            .animation(animation, value: isPresented)
        }
    }

    private func dismissModal() {
        isPresented = false
        onDismiss?()
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var showModal = true

        var body: some View {
            ZStack {
                Color.gray.ignoresSafeArea()

                Button("Show Modal") {
                    showModal = true
                }

                CustomModalView(isPresented: $showModal) {
                    ProfileModalview(
                        imageName: Constants.randomImage,
                        title: "Preview Title",
                        subtitle: "Preview Subtitle",
                        headline: "This is a preview headline",
                        onMarkPressed: {
                            showModal = false
                        }
                    )
                }
            }
        }
    }

    return PreviewWrapper()
}
