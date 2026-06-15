//
//  AppViewBuilder.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct AppViewBuilder<TabBarView: View, OnBoardingView: View>: View {
    
    var showTabBar: Bool = false
    
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
    }
    
}

private struct Preview: View {
    
    @State private var showTabBar = false
    
    var body: some View {
        AppViewBuilder(
            showTabBar: showTabBar,
            tabbarView: {
                ZStack {
                    Color.red.ignoresSafeArea()
                    Text("TabBar")
                }
            },
            onBoardingView: {
                ZStack {
                    Color.blue.ignoresSafeArea()
                    Text("OnBoarding")
                }
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
