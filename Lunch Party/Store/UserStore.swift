//
//  UserStore.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/16/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import Foundation

class UserStore: NSObject {
    
    var id: String!
    var profileImageUrl: String?
    var displayName: String?
    
    static let sharedInstance = UserStore()
    
    func setUserProfile(id: String, profileImageUrl: String?, displayName: String?) {
        self.id = id
        self.profileImageUrl = profileImageUrl
        self.displayName = displayName
    }
    
}
