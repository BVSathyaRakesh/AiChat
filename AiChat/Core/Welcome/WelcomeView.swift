//
//  WelcomeView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct WelcomeView: View {
    
    @State var imageName = Constants.randomImage
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                ImageLoaderView(urlString: imageName)
                    .ignoresSafeArea()
                titleSection
                    .padding(.top, 24)
                ctaButtons
                    .padding(16)
                policyLinks
            }
        }
    }
    
    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("AI Chat 🤙")
                .font(.title)
                .fontWeight(.bold)
            
            Text("YouTube @SwitftulThinking")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var ctaButtons: some View {
        VStack {
            NavigationLink {
                OnBoardingIntroView()
            } label: {
                Text("Get Started")
                    .callToFunctionButton()
            }
            Text("Already Have an account? Sign In")
                .underline()
                .font(.body)
                .padding(8)
                .tappableBackground()
                .onTapGesture {
                    
                }
        }
    }
    
    private var policyLinks: some View {
        HStack(spacing: 8) {
            Link("Terms of Service", destination: URL(string: Constants.termsOfServiceURL)!)
            Circle()
                .frame(width: 4, height: 4)
                .foregroundStyle(.red)
            Link("Privacy Policy", destination: URL(string: Constants.privacyPolicyURL)!)
        }
    }
}

#Preview {
    WelcomeView()
}
