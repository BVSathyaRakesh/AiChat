//
//  WelcomeView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to AIChat !")
                    .frame(maxHeight: .infinity)
                NavigationLink {
                    OnBoardingCompletedView()
                } label: {
                    Text("Get Started")
                        .callToFunctionButton()
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    WelcomeView()
}
