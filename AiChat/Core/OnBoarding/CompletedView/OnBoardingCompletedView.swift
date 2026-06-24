//
//  OnBoardingCompletedView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct OnBoardingCompletedView: View {

    @Environment(AppState.self) private var root
    @Environment(UserManager.self) private var userManager
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
        do {
            let colorHex = selectedColor.toHex() ?? "#4ECDC4"
            try await userManager.completeOnboarding(profileColorHex: colorHex)
            root.updateViewState(showTabBarView: true)
        } catch {
            print("Failed to complete onboarding: \(error)")
            // Still allow user to proceed even if update fails
            root.updateViewState(showTabBarView: true)
        }
    }
}

#Preview {
    NavigationStack {
        OnBoardingCompletedView()
            .environment(AppState())
            .environment(UserManager(userService: MockUserService()))
    }
}
