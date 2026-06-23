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
        
    }
    
   private func checkUserStatus() async {
       if let user = authService.getAuthenticatedUser() {
           // User is authenticated
           print("user is already  Authenticated: \(user.uid)")
       } else {
           do {
                // User is not authenticated
               let result = try await authService.signInAnonymously()
               print("user is signed in anonymously: \(result.user.uid)")
           } catch {
               print(error)
           }
       }
    }
}

#Preview("TabBar preview") {
    AppView(appState: AppState(showTabBar: true))
}
#Preview("Welcome preview") {
    AppView(appState: AppState(showTabBar: false))
}
