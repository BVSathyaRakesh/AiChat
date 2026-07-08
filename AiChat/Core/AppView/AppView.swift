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

    enum Event: LoggableEvent {
        case alpha
        case beta
        case gamma
        case delta

        var eventName: String {
            switch self {
            case .alpha, .beta, .gamma:
                return "Event_Gamma"
            case .delta:
                return "Event_Delta"
            }
        }

        var parameters: [String: Any]? {
            switch self {
            case .alpha, .beta:
                return [
                    "aaa": true,
                    "bbb": 123
                ]
            default:
                return nil
            }
        }

        var type: LogType {
            switch self {
            case .alpha:
                return .info
            case .beta:
                return .analytic
            case .gamma:
                return .warning
            case .delta:
                return .severe
            }
        }
    }

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
            logManager.trackEvent(event: Event.alpha)
            logManager.trackEvent(event: Event.beta)
            logManager.trackScreenEvent(event: Event.gamma)
            logManager.trackScreenEvent(event: Event.delta)
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
        .environment(LogManager(services: [ConsoleService()]))
        .previewEnvironment()
}
#Preview("Welcome preview") {
    AppView(appState: AppState(showTabBar: false))
        .environment(AuthManager(authService: MockAuthService()))
        .environment(UserManager(services: MockUserServices(userModal: .mock)))
        .environment(LogManager(services: [ConsoleService()]))
        .previewEnvironment()
}
