//
//  AppView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct AppView: View {
    
    @AppStorage("showTabBarView") var showTabBar = false
    
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

#Preview("TabBar preview") {
    AppView(showTabBar: true)
}
#Preview("Welcome preview") {
    AppView(showTabBar: false)
}
