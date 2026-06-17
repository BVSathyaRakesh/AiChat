//
//  OnBoardingCompletedView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct OnBoardingCompletedView: View {
    
    @Environment(AppState.self) private var root
    @State private var isCompletedProfileSetUp = false
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
        .safeAreaInset(edge: .bottom, content: {
           ctaButton
        })
        .padding(16)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var ctaButton: some View {
        Button {
            onFinishButtonPressed()
        } label: {
            ZStack {
                if isCompletedProfileSetUp {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Finish")
                }
            }
            .callToFunctionButton()
        }
        .disabled(isCompletedProfileSetUp)
    }
    
    func onFinishButtonPressed() {
        // other logic to complete onboarding
        isCompletedProfileSetUp = true
        Task {
            try await  Task.sleep(for: .seconds(3))
            isCompletedProfileSetUp = false
            root.updateViewState(showTabBarView: true)
        }
    }
}

#Preview {
    NavigationStack {
        OnBoardingCompletedView()
            .environment(AppState())
    }
}
