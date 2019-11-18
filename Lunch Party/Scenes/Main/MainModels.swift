//
//  MainModels.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/17/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import CoreLocation

enum ListBusinesses {
    enum FetchBusinesses {
        struct Request {
            var searchTerm: String
            var coordinates: CLLocationCoordinate2D
        }
        struct Response {
            var businesses: [Business]
        }
        struct ViewModel {
            struct DisplayedBusiness {
                var id: String
                var title: String
                var subtitle: String
            }
            var businesses: [DisplayedBusiness]
        }
    }
}
