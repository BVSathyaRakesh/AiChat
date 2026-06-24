//
//  SignInWithGoogleButtonView.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//

import SwiftUI

struct SignInWithGoogleButtonView: View {
    let cornerRadius: CGFloat

    init(cornerRadius: CGFloat = 16) {
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "g.circle.fill")
                .font(.title2)

            Text("Sign in with Google")
                .font(.headline)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .background(Color(red: 0.26, green: 0.52, blue: 0.96)) // Google Blue
        .cornerRadius(cornerRadius)
    }
}

#Preview {
    VStack(spacing: 16) {
        SignInWithGoogleButtonView()
            .padding()

        SignInWithGoogleButtonView(cornerRadius: 10)
            .padding()
    }
}
