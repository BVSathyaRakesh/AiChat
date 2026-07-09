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

    // Get Dependencies from AppDelegate (scheme-based configuration)
    var dependencies: Dependencies {
        delegate.dependencies
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(dependencies)
                .environment(dependencies.authManager)
                .environment(dependencies.userManager)
                .environment(dependencies.avatarManager)
                .environment(dependencies.chatManager)
                .environment(dependencies.aiImanager)
                .environment(dependencies.logManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    var dependencies: Dependencies!

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
        dependencies = Dependencies(configuration: config)
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

@Observable
@MainActor
final class Dependencies {

    // MARK: - Existing Managers (keep as-is)
    let authManager: AuthManager
    let userManager: UserManager
    let aiImanager: AIManager
    let avatarManager: AvatarManager
    let chatManager: ChatManager
    let logManager: LogManager

    // MARK: - NEW: Repositories
    let avatarRepository: AvatarRepositoryProtocol
    let userRepository: UserRepositoryProtocol
    let authRepository: AuthRepositoryProtocol
    
    init(configuration: BuildConfiguration) {
        
        switch configuration {
        case .mock:
            authManager = AuthManager(authService: MockAuthService())
            userManager = UserManager(services: MockUserServices())
            aiImanager = AIManager(aiService: MockAIService())
            avatarManager = AvatarManager(service: MockAvatarService(), local: MockLocalAvatarPersistence())
            chatManager = ChatManager(chatService: FirebaseChatMessageService())
            logManager = LogManager(services: [
                ConsoleService(printParameters: false)
            ])
        case .dev:
            authManager = AuthManager(authService: FirebaseAuthService())
            userManager = UserManager(services: ProductionUserServices())
            aiImanager = AIManager(aiService: PollinationsAIService())
            avatarManager = AvatarManager(service: FirebaseAvatarService(), local: SwiftDataLocalAvatarPersistence())
            chatManager = ChatManager(chatService: FirebaseChatMessageService())
            logManager = LogManager(services: [
                ConsoleService(), FirebaseAnalyticsService()
            ])
        case .production:
            authManager = AuthManager(authService: FirebaseAuthService())
            userManager = UserManager(services: ProductionUserServices())
            aiImanager = AIManager(aiService: PollinationsAIService())
            avatarManager = AvatarManager(service: FirebaseAvatarService(), local: SwiftDataLocalAvatarPersistence())
            chatManager = ChatManager(chatService: FirebaseChatMessageService())
            logManager = LogManager(services: [
                FirebaseAnalyticsService()
            ])
        }
        
        // NEW: Initialize repositories (same for all configurations)
        avatarRepository = RemoteAvatarRepository(avatarManager: avatarManager)
        userRepository = UserRepository(userManager: userManager)
        authRepository = AuthRepository(authManager: authManager)
    }
    
    // MARK: - NEW: ViewModel Factories
    
    /// Factory method to create ProfileViewModel with all dependencies
    func makeProfileViewModel() -> ProfileViewModel {
        // Create Use Cases
        let fetchUserAvatarsUseCase = RemoteFetchUserAvatarsUseCase(
            avatarRepository: avatarRepository
        )
        
        let deleteAvatarUseCase = DefaultDeleteAvatarUseCase(
            avatarRepository: avatarRepository
        )
        
        let getCurrentUserUseCase = DefaultGetCurrentUserUseCase(
            userRepository: userRepository,
            authRepository: authRepository
        )
        
        // Create and return ViewModel
        return ProfileViewModel(
            fetchUserAvatarsUseCase: fetchUserAvatarsUseCase,
            deleteAvatarUseCase: deleteAvatarUseCase,
            getCurrentUserUseCase: getCurrentUserUseCase
        )
    }
}

extension View {
     func previewEnvironment() -> some View {
         let mockDependencies = Dependencies(configuration: .mock)
         return self
             .environment(mockDependencies)
             .environment(mockDependencies.authManager)
             .environment(mockDependencies.userManager)
             .environment(mockDependencies.avatarManager)
             .environment(mockDependencies.chatManager)
             .environment(mockDependencies.aiImanager)
             .environment(mockDependencies.logManager)
     }
 }
