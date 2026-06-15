//
//  AppView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct AppView: View {
    
    @State var appState: AppState = AppState()
    
    var body: some View {
        AppViewBuilder(
            showTabBar: appState.showTabBar,
            tabbarView: {
                TabBarView()
            },
            onBoardingView: {
               WelcomeView()
            }
        )
        .environment(appState)
    }
}

#Preview("TabBar preview") {
    AppView(appState: AppState(showTabBar: true))
}
#Preview("Welcome preview") {
    AppView(appState: AppState(showTabBar: false))
}
