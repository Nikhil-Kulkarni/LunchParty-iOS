//
//  NetworkHandler.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/18/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkHandler {
    
    static func get(url: String, headers: [String : String], completion: @escaping (JSON?, Bool) -> Void) {
        let queue = DispatchQueue(label: "com.nikhil.lunchparty.networkhandler", qos: .userInitiated)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: headers)
            .responseJSON(queue: queue, options: .allowFragments) { (data) in
                if (data.response?.statusCode != 200) {
                    completion(nil, false)
                    return
                }
                
                guard let data = data.result.value else {
                    completion(nil, false)
                    return
                }
                
                let jsonResponse = JSON(data)
                completion(jsonResponse, true)
        }
    }
    
}
