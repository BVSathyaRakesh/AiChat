//
//  AppView.swift
//  AiChat
//
//  Created by Sathya Kumar on 15/06/26.
//

import SwiftUI

struct AppView: View {
    
    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    @Environment(LogManager.self) private var logManager
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
        .onAppear {
            logManager.identifyUser(userid: "abc123", name: "nick", email: "hi@hi.com")
            logManager.addUserproperties(properties: UserModel.mock.eventParameters)
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
        if let user = authManager.auth {
            print("User is already signed in: \(user.uid)")
            do {
                // User is not authenticated, sign in anonymously
                try  await userManager.login(auth: user, isNewUser: false)
            } catch {
                print("failed to login to existing user \(error)")
                try? await Task.sleep(for: .seconds(5))
                await checkUserStatus()
            }
        } else {
            do {
                let result =  try await authManager.signInAnonymously()
                print("sign in anonymously success: \(result.user.uid)")
                try await userManager.login(auth: result.user, isNewUser: result.isNewuser)
            } catch {
                print(error)
                try? await Task.sleep(for: .seconds(5))
               await checkUserStatus()
            }
        }
        // Don't change showTabBar here - respect persisted state from UserDefaults
    }
}

#Preview("TabBar preview") {
    AppView(appState: AppState(showTabBar: true))
        .environment(AuthManager(authService: MockAuthService()))
        .environment(UserManager(services: MockUserServices(userModal: .mock)))
        .previewEnvironment()
}
#Preview("Welcome preview") {
    AppView(appState: AppState(showTabBar: false))
        .environment(AuthManager(authService: MockAuthService()))
        .environment(UserManager(services: MockUserServices(userModal: .mock)))
        .previewEnvironment()
}
