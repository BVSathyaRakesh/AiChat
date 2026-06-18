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
    
    func tappableBackground() -> some View {
        background(Color.black.opacity((0.001)))
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
}
