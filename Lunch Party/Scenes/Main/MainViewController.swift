//
//  MainViewController.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/16/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import CoreLocation

private let kSearchBarHeight: CGFloat = 50.0
private let kSearchBarSideMargin: CGFloat = 22.0
private let kSearchBarTopMargin: CGFloat = 25.0

protocol ListBusinessesDisplayLogic: class {
    func displayFetchedBusinesses(viewModel: ListBusinesses.FetchBusinesses.ViewModel)
}

class MainViewController: UIViewController {
    
    private var interactor: ListBusinessesBusinessLogic?
    
    private var searchTextField: TextField!
    private var tableView: MainTableView!
    private var businesses: [ListBusinesses.FetchBusinesses.ViewModel.DisplayedBusiness] = []
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        setup()
        setupSearchTextField()
        setupTableView()
    }
    
    private func setup() {
        let businessesInteractor = ListBusinessesInteractor()
        let presenter = ListBusinessesPresenter()
        self.interactor = businessesInteractor
        businessesInteractor.presenter = presenter
        presenter.viewController = self
    }
    
    private func setupSearchTextField() {
        let width = view.width() - 2 * kSearchBarSideMargin
        searchTextField = TextField(frame: CGRect(x: kSearchBarSideMargin, y: kSearchBarTopMargin, width: width, height: kSearchBarHeight))
        searchTextField.addTarget(self, action: #selector(textFieldTextDidChange(_:)), for: .editingChanged)
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)

        //To apply corner radius
        searchTextField.layer.cornerRadius = searchTextField.frame.size.height / 2

        //To apply border
        searchTextField.layer.borderWidth = 0.25
        searchTextField.layer.borderColor = UIColor.white.cgColor

        //To apply Shadow
        searchTextField.layer.shadowOpacity = 1
        searchTextField.layer.shadowRadius = 3.0
        searchTextField.layer.shadowOffset = CGSize.zero // Use any CGSize
        searchTextField.layer.shadowColor = UIColor.gray.cgColor

        //To apply padding
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: searchTextField.frame.height))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
        
        view.addSubview(searchTextField)
    }
    
    private func setupTableView() {
        // TODO
    }
    
    @objc func textFieldTextDidChange(_ textField: UITextField) {
        guard let searchTerm = textField.text else { return }
        if !searchTerm.isEmpty {
            let request = ListBusinesses.FetchBusinesses.Request(searchTerm: searchTerm, coordinates: CLLocationCoordinate2D(latitude: 34.061034, longitude: -118.442763))
            interactor?.fetchBusinesses(request: request)
        }
    }
    
}

extension MainViewController: ListBusinessesDisplayLogic {
    
    func displayFetchedBusinesses(viewModel: ListBusinesses.FetchBusinesses.ViewModel) {
        self.businesses = viewModel.businesses
        self.tableView.reloadData()
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableView.businessCellReuseIdentifier, for: indexPath) as! BusinessTableViewCell
        let business = self.businesses[indexPath.row]
        cell.bind(viewModel: business)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
}
