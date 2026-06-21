//
//  OnBoardingCompletedView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct OnBoardingCompletedView: View {

    @Environment(AppState.self) private var root
    var selectedColor: Color = .orange

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Setup Completed!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color(selectedColor))

            Text("We've setup your profile and you're readt to strat chatting!")
                .font(.title)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)

        }
        .frame(maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
            AsyncActionButton(title: "Finish") {
                await onFinishButtonPressed()
            }
        }
        .padding(16)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func onFinishButtonPressed() async {
        // other logic to complete onboarding
        try? await Task.sleep(for: .seconds(3))
        root.updateViewState(showTabBarView: true)
    }
}

#Preview {
    NavigationStack {
        OnBoardingCompletedView()
            .environment(AppState())
    }
}
