//
//  AppView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct AppView: View {
    
    @Environment(\.authService) private var authService
    @State var appState: AppState = AppState()
    
    var body: some View {
        AppViewBuilder(
            showTabBar: appState.showTabBar,
            tabbarView: {
                TabBarView()
            },
            onBoardingView: {
                NavigationStack {
                    WelcomeView()
                }
            }
        )
        .environment(appState)
        .task {
            await checkUserStatus()
        }
        .onChange(of: appState.showTabBar) { _, showTabBar in
            if !showTabBar {
                Task {
                    await checkUserStatus()
                }
            }
        }
    }
    
   private func checkUserStatus() async {
       if authService.getAuthenticatedUser() == nil {
           do {
               // User is not authenticated, sign in anonymously
               try await authService.signInAnonymously()
           } catch {
               print(error)
           }
       }
       // Don't change showTabBar here - respect persisted state from UserDefaults
    }
}

#Preview("TabBar preview") {
    AppView(appState: AppState(showTabBar: true))
}
#Preview("Welcome preview") {
    AppView(appState: AppState(showTabBar: false))
}
