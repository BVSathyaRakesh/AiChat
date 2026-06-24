//
//  UserInfo+Firebase.swift
//  AiChat
//
//  Created by Sathya Kumar on 24/06/26.
//

import FirebaseAuth

extension UserAuthInfo {
    init(user: User){
        self.uid = user.uid
        self.email = user.email
        self.isAonymous = user.isAnonymous
        self.creationDate = user.metadata.creationDate
        self.lastSignInDate = user.metadata.lastSignInDate
    }
}
