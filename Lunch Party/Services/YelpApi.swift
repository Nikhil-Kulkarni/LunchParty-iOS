//
//  YelpApi.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/18/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import CoreLocation

private let yelpToken = "Bearer KX8EyvvJv5EZXTNAg4jsjOWIE8VXeMRRYzOgZZNs-R5Pi_WT5hVrR5vdlISvAyEKMP5JytdRo5pYvVLyLQlp79Ahif04orZuEUEpvPaVbd32CwtLisny0ro8fkHKXXYx"
private let baseUrl = "https://api.yelp.com/v3/businesses/search"
private let idUrl = "https://api.yelp.com/v3/businesses/"

class YelpApi: BusinessesApi {
    
    private let headers = ["AUTHORIZATION" : yelpToken]
    
    func fetchBusinesses(searchTerm: String, location: CLLocationCoordinate2D, completion: @escaping (Result<[Business]>) -> Void) {
        guard var url = URLComponents(string: baseUrl) else {
            completion(Result.Error(error: BusinessesError.CannotFetch("Failed to create url")))
            return
        }
        url.queryItems = [
            URLQueryItem(name: "term", value: searchTerm),
            URLQueryItem(name: "latitude", value: "\(location.latitude)"),
            URLQueryItem(name: "longitude", value: "\(location.longitude)"),
            URLQueryItem(name: "categories", value: "restaurants,food")
        ]
        
        guard let urlString = url.string else {
            completion(Result.Error(error: BusinessesError.CannotFetch("Failed to create url string")))
            return
        }
        
        NetworkHandler.get(url: urlString, headers: headers) { (json, success) in
            if (!success) {
                completion(Result.Error(error: BusinessesError.CannotFetch("Yelp request failed")))
                return
            }
            
            guard let jsonResponse = json?.dictionaryValue else {
                completion(Result.Error(error: BusinessesError.CannotFetch("Yelp response invalid")))
                return
            }
            
            guard let businessesArray = jsonResponse["businesses"]?.arrayValue else {
                let error = BusinessesError.CannotFetch("Failed to parse yelp response")
                completion(Result.Error(error: error))
                return
            }
            
            var businesses: [Business] = []
            for business in businessesArray {
                businesses.append(Business(json: business.dictionaryValue))
            }
            completion(Result.Success(result: businesses))
        }
    }
    
    func fetchBusiness(id: String, completion: @escaping (Result<Business>) -> Void) {
        guard var url = URLComponents(string: baseUrl) else {
            completion(Result.Error(error: BusinessesError.CannotFetch("Failed to create url")))
            return
        }
        url.queryItems = [URLQueryItem(name: "id", value: id)]
        
        guard let urlString = url.string else {
            completion(Result.Error(error: BusinessesError.CannotFetch("Failed to create url string")))
            return
        }
        
        NetworkHandler.get(url: urlString, headers: headers) { (json, success) in
            if (!success) {
                completion(Result.Error(error: BusinessesError.CannotFetch("Yelp request failed")))
                return
            }
            
            guard let jsonResponse = json?.dictionaryValue else {
                completion(Result.Error(error: BusinessesError.CannotFetch("Yelp response invalid")))
                return
            }
            
            let business = Business(json: jsonResponse)
            completion(Result.Success(result: business))
        }
    }
    
}
