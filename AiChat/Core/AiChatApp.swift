//
//  AiChatApp.swift
//  AiChat
//
//  Created by Sathya Kumar on 14/06/26.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct AiChatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
