//
//  UserModel.swift
//  AiChat
//
//  Created by Sathya Kumar on 20/06/26.
//

import Foundation
import SwiftUI

struct UserModel: Codable {
    let userId: String
    let email: String?
    let isAnonymous: Bool?
    let creationDate: Date?
    let creationVersion: String?
    let lastSignInDate: Date?
    let didCompleteOnBoarding: Bool?
    let profileColorHex: String?
    
    init(
        userId: String,
        email: String? = nil,
        isAnonymous: Bool? = nil,
        creationDate: Date? = nil,
        creationVersion: String? = nil,
        lastSignInDate: Date? = nil,
        didCompleteOnBoarding: Bool? = nil,
        profileColorHex: String? = nil
    ) {
        self.userId = userId
        self.email = email
        self.isAnonymous = isAnonymous
        self.creationDate = creationDate
        self.creationVersion = creationVersion
        self.lastSignInDate = lastSignInDate
        self.didCompleteOnBoarding = didCompleteOnBoarding
        self.profileColorHex = profileColorHex
    }
    
    init(auth: UserAuthInfo, createionVersion: String? = nil) {
        self.init(
            userId: auth.uid,
            email: auth.email,
            isAnonymous: auth.isAnonymous,
            creationDate: auth.creationDate,
            creationVersion: createionVersion,
            lastSignInDate: auth.lastSignInDate
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case isAnonymous = "is_anonymous"
        case creationDate = "creation_date"
        case creationVersion = "creation_version"
        case lastSignInDate = "last_sign_in_date"
        case didCompleteOnBoarding = "did_complete_on_boarding"
        case profileColorHex = "profile_color_hex"
    }

    var profileColor: Color? {
        guard let hex = profileColorHex else { return .accent }
        return Color(hex: hex)
    }

    var eventParameters: [String: Any] {
        let dict: [String: Any?] = [
            "user_\(CodingKeys.userId.rawValue)": userId,
            "user_\(CodingKeys.email.rawValue)": email,
            "user_\(CodingKeys.isAnonymous.rawValue)": isAnonymous,
            "user_\(CodingKeys.creationDate.rawValue)": creationDate,
            "user_\(CodingKeys.creationVersion.rawValue)": creationVersion,
            "user_\(CodingKeys.lastSignInDate.rawValue)": lastSignInDate,
            "user_\(CodingKeys.didCompleteOnBoarding.rawValue)": didCompleteOnBoarding,
            "user_\(CodingKeys.profileColorHex.rawValue)": profileColorHex
        ]
        return dict.compactMapValues({ $0 })
    }

    static var mock: Self {
        mocks[0]
    }

    static var mocks: [UserModel] = [
        // Current user - completed onboarding
        UserModel(
            userId: "mock_user_123",
            email: "hello@swiftful-thinking.com",
            isAnonymous: false,
            creationDate: Date().addingTimeInterval(-86400 * 30),
            creationVersion: "1.0.0",
            lastSignInDate: Date(),
            didCompleteOnBoarding: true,
            profileColorHex: "#4ECDC4"
        ),
        // New user - not completed onboarding
        UserModel(
            userId: UUID().uuidString,
            creationDate: Date().addingTimeInterval(-86400 * 1),
            didCompleteOnBoarding: false,
            profileColorHex: nil
        ),
        // Regular user - completed onboarding
        UserModel(
            userId: UUID().uuidString,
            creationDate: Date().addingTimeInterval(-86400 * 15),
            didCompleteOnBoarding: true,
            profileColorHex: "#FF6B6B"
        ),
        // Active user - completed onboarding
        UserModel(
            userId: UUID().uuidString,
            creationDate: Date().addingTimeInterval(-86400 * 60),
            didCompleteOnBoarding: true,
            profileColorHex: "#95E1D3"
        ),
        // Long-time user - completed onboarding
        UserModel(
            userId: UUID().uuidString,
            creationDate: Date().addingTimeInterval(-86400 * 180),
            didCompleteOnBoarding: true,
            profileColorHex: "#F38181"
        )
    ]
}
