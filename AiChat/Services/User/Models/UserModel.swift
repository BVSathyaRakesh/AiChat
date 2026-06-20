//
//  UserModel.swift
//  AiChat
//
//  Created by Sathya Kumar on 20/06/26.
//

import Foundation
import SwiftUI

struct UserModel {
    let userId: String
    let dateCreated: Date?
    let didCompleteOnBoarding: Bool?
    let profileColorHex: String?

    var profileColor: Color? {
        guard let hex = profileColorHex else { return .accent }
        return Color(hex: hex)
    }

    static var mock: Self {
        mocks[0]
    }

    static var mocks: [UserModel] = [
        // Current user - completed onboarding
        UserModel(
            userId: "current-user-id",
            dateCreated: Date().addingTimeInterval(-86400 * 30),
            didCompleteOnBoarding: true,
            profileColorHex: "#4ECDC4"
        ),
        // New user - not completed onboarding
        UserModel(
            userId: UUID().uuidString,
            dateCreated: Date().addingTimeInterval(-86400 * 1),
            didCompleteOnBoarding: false,
            profileColorHex: nil
        ),
        // Regular user - completed onboarding
        UserModel(
            userId: UUID().uuidString,
            dateCreated: Date().addingTimeInterval(-86400 * 15),
            didCompleteOnBoarding: true,
            profileColorHex: "#FF6B6B"
        ),
        // Active user - completed onboarding
        UserModel(
            userId: UUID().uuidString,
            dateCreated: Date().addingTimeInterval(-86400 * 60),
            didCompleteOnBoarding: true,
            profileColorHex: "#95E1D3"
        ),
        // Long-time user - completed onboarding
        UserModel(
            userId: UUID().uuidString,
            dateCreated: Date().addingTimeInterval(-86400 * 180),
            didCompleteOnBoarding: true,
            profileColorHex: "#F38181"
        )
    ]
}
