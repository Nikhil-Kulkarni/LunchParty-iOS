//
//  MainPresenter.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/17/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import Foundation

protocol ListBusinessesPresentationLogic {
    func presentFetchedBusinesses(response: ListBusinesses.FetchBusinesses.Response)
}

class ListBusinessesPresenter: ListBusinessesPresentationLogic {
    
    weak var viewController: ListBusinessesDisplayLogic?
    
    func presentFetchedBusinesses(response: ListBusinesses.FetchBusinesses.Response) {
        var displayedBusinesses: [ListBusinesses.FetchBusinesses.ViewModel.DisplayedBusiness] = []
        for business in response.businesses {
            var subtitle: String = ""
            if let city = business.location?.city, let state = business.location?.state {
                subtitle = "\(city), \(state)"
            }
            let displayedBusiness = ListBusinesses.FetchBusinesses.ViewModel.DisplayedBusiness(id: business.id, title: business.name, subtitle: subtitle)
            displayedBusinesses.append(displayedBusiness)
        }
        let viewModel = ListBusinesses.FetchBusinesses.ViewModel(businesses: displayedBusinesses)
        viewController?.displayFetchedBusinesses(viewModel: viewModel)
    }
    
}
