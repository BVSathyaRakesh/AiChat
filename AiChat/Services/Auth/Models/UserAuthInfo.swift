//
//  UserAuthInfo.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//

import FirebaseAuth

struct UserAuthInfo: Sendable {
    let uid: String
    let email: String?
    let isAnonymous: Bool?
    let creationDate: Date?
    let lastSignInDate: Date?
    
    init(
        uid: String,
        email: String? = nil,
        isAonymous: Bool? = false,
        creationDate: Date? = nil,
        lastSignInDate: Date? = nil
    ) {
        self.uid = uid
        self.email = email
        self.isAnonymous = isAonymous
        self.creationDate = creationDate
        self.lastSignInDate = lastSignInDate
    }
    
    static func mock(isAnonymous: Bool = false) -> Self {
        UserAuthInfo(
            uid: "mock-user1",
            email: "hello@swiftful-thinking.com",
            isAonymous: isAnonymous,
            creationDate: .now,
            lastSignInDate: .now
        )
    }
}
