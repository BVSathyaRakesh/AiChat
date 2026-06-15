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
}
