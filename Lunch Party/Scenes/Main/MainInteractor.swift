//
//  MainInteractor.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/17/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import CoreLocation

protocol ListBusinessesBusinessLogic {
    func fetchBusinesses(request: ListBusinesses.FetchBusinesses.Request)
}

protocol ListBusinessesDataStore {
    var businsesses: [Business]? { get }
    var businessesMap: [String : Business] { get }
}

class ListBusinessesInteractor: ListBusinessesBusinessLogic, ListBusinessesDataStore {
    var presenter: ListBusinessesPresentationLogic?
    var businessesMap: [String : Business] = [:]
    
    var worker = BusinessesWorker(api: YelpApi())
    var businsesses: [Business]?
    
    func fetchBusinesses(request: ListBusinesses.FetchBusinesses.Request) {
        worker.fetchBusinesses(searchTerm: request.searchTerm, location: request.coordinates) { (response) in
            switch response {
            case .Success(let result):
                self.businsesses = result
                for business in result {
                    self.businessesMap[business.id] = business
                }
                let response = ListBusinesses.FetchBusinesses.Response(businesses: result)
                self.presenter?.presentFetchedBusinesses(response: response)
            case .Error:
                self.businsesses = nil
            }
        }
    }
}
