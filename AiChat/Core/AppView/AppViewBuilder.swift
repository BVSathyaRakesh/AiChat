//
//  AppViewBuilder.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct AppViewBuilder<TabBarView: View, OnBoardingView: View>: View {
    
    var showTabBar: Bool = true
    
    @ViewBuilder var tabbarView: TabBarView
    @ViewBuilder var onBoardingView: OnBoardingView
    
    var body: some View {
        ZStack {
            if showTabBar {
                tabbarView
                    .transition(.move(edge: .trailing))
            } else {
                onBoardingView
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.smooth, value: showTabBar)
        .id(showTabBar)
    }
    
}

private struct Preview: View {
    
    @State private var showTabBar = true
    
    var body: some View {
        AppViewBuilder(
            showTabBar: showTabBar,
            tabbarView: {
                TabBarView()
            },
            onBoardingView: {
                WelcomeView()
            }
        )
        .onTapGesture {
            showTabBar.toggle()
        }
    }
}

#Preview{
    Preview()
}
