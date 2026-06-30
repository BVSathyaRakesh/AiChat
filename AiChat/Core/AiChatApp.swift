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
                AppView()
                .environment(delegate.dependecies.authManager)
                .environment(delegate.dependecies.userManager)
                .environment(delegate.dependecies.aiImanager)
                .environment(delegate.dependecies.avatarManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var dependecies: Dependencies!
    
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
        
        dependecies = Dependencies()

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

struct Dependencies {
    let authManager: AuthManager!
    let userManager: UserManager!
    let aiImanager: AIManager!
    let avatarManager: AvatarManager!

    init() {
        authManager = AuthManager(authService: FirebaseAuthService())
        userManager = UserManager(services: ProductionUserServices())
        aiImanager = AIManager(aiService: PollinationsAIService())
        avatarManager = AvatarManager(service: FirebaseAvatarService())
    }
}

