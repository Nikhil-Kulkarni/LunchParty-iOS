//
//  Business.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/18/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class Business: NSObject {
    
    var id: String!
    var rating: Float!
    var price: String!
    var phone: String!
    var reviewCount: Int!
    var name: String!
    var url: String!
    var coordinates: CLLocationCoordinate2D?
    var imageUrl: String?
    var location: Location?
    var distance: Double!
    
    init(json: [String: JSON]) {
        self.id = json["id"]?.stringValue
        self.rating = json["rating"]?.floatValue
        self.price = json["price"]?.stringValue
        self.phone = json["display_phone"]?.stringValue
        self.reviewCount = json["review_count"]?.intValue
        self.name = json["name"]?.stringValue
        self.url = json["url"]?.stringValue
        self.imageUrl = json["image_url"]?.stringValue
        self.distance = json["distance"]?.doubleValue
        let coordinates = json["coordinates"]?.dictionaryValue
        let latitude = coordinates?["latitude"]?.doubleValue
        let longitude = coordinates?["longitude"]?.doubleValue
        
        if let latitude = latitude, let longitude = longitude {
            self.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        if let location = json["location"]?.dictionaryValue {
            self.location = Location(json: location)
        }
    }
    
}

class Location {
    
    var city: String!
    var country: String!
    var address: String?
    var state: String?
    var zipCode: String?
    
    init(json: [String : JSON]) {
        self.city = json["city"]?.stringValue
        self.country = json["country"]?.stringValue
        self.address = json["address1"]?.stringValue
        self.state = json["state"]?.stringValue
        self.zipCode = json["zip_code"]?.stringValue
    }
    
}
