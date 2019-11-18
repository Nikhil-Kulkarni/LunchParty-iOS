//
//  SCUtils.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/16/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import SCSDKLoginKit

private let kSCGraphQLQuery = "{me{displayName, externalId, bitmoji{avatar}}}"
private let kSCVariables = ["page": "bitmoji"]

class SCUtils {
    
    static func fetchSCUserData(completion: @escaping (Bool, String?, String?, String?) -> Void) {
        SCSDKLoginClient.fetchUserData(withQuery: kSCGraphQLQuery, variables: kSCVariables, success: { (resources) in
            guard let resources = resources,
                let data = resources["data"] as? [String : Any],
                let me = data["me"] as? [String: Any] else {
                    completion(false, nil, nil, nil)
                    return
            }
            
            let displayName = me["displayName"] as? String
            let externalId = me["externalId"] as? String
            var bitmojiAvatarUrl: String?
            if let bitmoji = me["bitmoji"] as? [String: Any] {
                bitmojiAvatarUrl = bitmoji["avatar"] as? String
            }
            
            guard let userId = externalId else {
                completion(false, nil, nil, nil)
                return
            }
            completion(true, userId, bitmojiAvatarUrl, displayName)
        }, failure: { (error, isUserLoggedOut) in
            completion(false, nil, nil, nil)
        })
    }
    
}

