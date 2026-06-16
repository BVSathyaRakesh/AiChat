//
//  OnBoardingCompletedView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct OnBoardingCompletedView: View {
    
    @Environment(AppState.self) private var root
    
    var body: some View {
        VStack {
            Text("OnBoarding Completed!")
                .frame(maxHeight: .infinity)
            Button {
                onFinishButtonPressed()
            } label: {
                Text("Finish")
                    .callToFunctionButton()
            }
        }
        .padding(16)
    }
    
    func onFinishButtonPressed() {
        // other logic to complete onboarding
        root.updateViewState(showTabBarView: true)
    }
}

#Preview {
    NavigationStack {
        OnBoardingCompletedView()
            .environment(AppState())
    }
}
