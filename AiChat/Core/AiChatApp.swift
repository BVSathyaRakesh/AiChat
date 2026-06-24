//
//  AiChatApp.swift
//  AiChat
//
//  Created by Sathya Kumar on 14/06/26.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct AiChatApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            EnvironmentViewBuilder {
                AppView()
            }
        }
    }
}

struct EnvironmentViewBuilder<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        content()
            .environment(\.authService, FirebaseAuthService())
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        // Configure Google Sign-In
        if let clientID = FirebaseApp.app()?.options.clientID {
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
        }

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
