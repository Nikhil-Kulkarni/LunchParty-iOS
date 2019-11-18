//
//  BusinessesAPI.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/18/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import CoreLocation

class BusinessesWorker {
    
    var api: BusinessesApi
    
    init(api: BusinessesApi) {
        self.api = api
    }
    
    func fetchBusinesses(searchTerm: String, location: CLLocationCoordinate2D, completion: @escaping (Result<[Business]>) -> Void) {
        api.fetchBusinesses(searchTerm: searchTerm, location: location) { (businesses) in
            DispatchQueue.main.async {
                completion(businesses)
            }
        }
    }
    
    func fetchBusiness(id: String, completion: @escaping (Result<Business>) -> Void) {
        api.fetchBusiness(id: id) { (business) in
            DispatchQueue.main.async {
                completion(business)
            }
        }
    }
    
}

// MARK: - Businesses api

protocol BusinessesApi {
    
    func fetchBusinesses(searchTerm: String, location: CLLocationCoordinate2D, completion: @escaping (Result<[Business]>) -> Void)
    func fetchBusiness(id: String, completion: @escaping (Result<Business>) -> Void)
    
}

enum BusinessesError: Error {
    case CannotFetch(String)
}

enum Result<U> {
    case Success(result: U)
    case Error(error: BusinessesError)
}
