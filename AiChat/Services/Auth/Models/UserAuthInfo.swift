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
    let isAonymous: Bool?
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
        self.isAonymous = isAonymous
        self.creationDate = creationDate
        self.lastSignInDate = lastSignInDate
    }
    
   
}
