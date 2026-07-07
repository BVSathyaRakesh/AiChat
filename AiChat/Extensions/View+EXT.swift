//
//  View+EXT.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI
extension View {
    func callToFunctionButton() -> some View {
        self
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.accent)
            .clipShape(RoundedRectangle(cornerRadius: 16.0))
    }
    
    func badgeButton() -> some View {
        self
            .font(.caption)
            .bold()
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))

    }
    
    func tappableBackground() -> some View {
        background(Color.black.opacity((0.001)))
    }
    
    func removeListRowFormatting() -> some View {
        self
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
    }
    
    func addingGradientBackgroundFortext() -> some View {
        background {
            LinearGradient(
                colors: [
                    Color.black.opacity(0),
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.4)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func customModal<Content: View>(
        isPresented: Binding<Bool>,
        overlayColor: Color = .black,
        overlayOpacity: Double = 0.6,
        contentPadding: CGFloat = 40,
        transition: AnyTransition = .slide,
        animation: Animation = .bouncy,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
                .disabled(isPresented.wrappedValue)

            CustomModalView(
                isPresented: isPresented,
                overlayColor: overlayColor,
                overlayOpacity: overlayOpacity,
                contentPadding: contentPadding,
                transition: transition,
                animation: animation,
                onDismiss: onDismiss,
                content: content
            )
        }
    }
}
