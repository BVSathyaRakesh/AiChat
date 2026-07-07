//
//  AiChatApp.swift
//  AiChat
//
//  Created by Sathya Kumar on 14/06/26.
//

import SwiftUI
import SwiftData
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
                .environment(delegate.dependecies.chatManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var dependecies: Dependencies!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
       
     let config: BuildConfiguration
       #if MOCK
        config = .mock
       #elseif DEV
        config = .dev
       #else
        config = .production
       #endif
        config.configure()
        dependecies = Dependencies(configuration: config)
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
          #if MOCK
        // Mock build doesn't require Firebase configuration
        return false
          #elseif DEV
        return GIDSignIn.sharedInstance.handle(url)
          #else
        return GIDSignIn.sharedInstance.handle(url)
          #endif
    }
}

enum BuildConfiguration {
    case mock, dev, production
    
    func configure() {
        switch self {
        case .mock:
            print("Mock build doesn't require Firebase configuration")
        case .dev:
            registerFireBase()
        case .production:
            registerFireBase()
        }
    }
    
    private func registerFireBase() {
        FirebaseApp.configure()
         // Configure Google Sign-In
        if let clientID = FirebaseApp.app()?.options.clientID {
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
        }
    }
}

struct Dependencies {
    let authManager: AuthManager!
    let userManager: UserManager!
    let aiImanager: AIManager!
    let avatarManager: AvatarManager!
    let chatManager: ChatManager!
    
    init(configuration: BuildConfiguration) {
        
        switch configuration {
        case .mock:
            authManager = AuthManager(authService: MockAuthService())
            userManager = UserManager(services: MockUserServices())
            aiImanager = AIManager(aiService: MockAIService())
            avatarManager = AvatarManager(service: MockAvatarService(), local: MockLocalAvatarPersistence())
            chatManager = ChatManager(chatService: FirebaseChatMessageService())
        case .dev:
            authManager = AuthManager(authService: FirebaseAuthService())
            userManager = UserManager(services: ProductionUserServices())
            aiImanager = AIManager(aiService: PollinationsAIService())
            avatarManager = AvatarManager(service: FirebaseAvatarService(), local: SwiftDataLocalAvatarPersistence())
            chatManager = ChatManager(chatService: FirebaseChatMessageService())
        case .production:
            authManager = AuthManager(authService: FirebaseAuthService())
            userManager = UserManager(services: ProductionUserServices())
            aiImanager = AIManager(aiService: PollinationsAIService())
            avatarManager = AvatarManager(service: FirebaseAvatarService(), local: SwiftDataLocalAvatarPersistence())
            chatManager = ChatManager(chatService: FirebaseChatMessageService())
        }
    }
}

extension View {
    func previewEnvironment(
        isSignedIn: Bool = true,
        shouldFail: Bool = false,
        isEmpty: Bool = false,
        delay: CGFloat = 0
    ) -> some View {
        self
            .environment(AIManager(aiService: MockAIService()))
            .environment(AvatarManager(
                service: MockAvatarService(shouldFail: shouldFail, isEmpty: isEmpty, delay: delay),
                local: MockLocalAvatarPersistence()
            ))
            .environment(UserManager(services: MockUserServices(userModal: isSignedIn ? .mock : nil)))
            .environment(AuthManager(authService: MockAuthService(user: isSignedIn ? .mock() : nil)))
            .environment(ChatManager(chatService: MockChatMessageService()))
            .environment(AppState())
    }
}
