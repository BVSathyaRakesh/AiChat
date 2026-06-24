//
//  SignInWithGoogleHelper.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}

final class SignInWithGoogleHelper {

    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = TopViewControllerHelper.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }

        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }

        let accessToken = gidSignInResult.user.accessToken.tokenString
        let name = gidSignInResult.user.profile?.name
        let email = gidSignInResult.user.profile?.email

        return GoogleSignInResultModel(
            idToken: idToken,
            accessToken: accessToken,
            name: name,
            email: email
        )
    }
}

// Helper for getting top view controller
final class TopViewControllerHelper {
    static let shared = TopViewControllerHelper()
    private init() {}

    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController

        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
