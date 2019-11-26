//
//  MainContentContainerView.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/19/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import CoreLocation

private let kSearchBarHeight: CGFloat = 50.0
private let kSearchBarSideMargin: CGFloat = 22.0
private let kSearchBarTopMargin: CGFloat = 25.0
private let kSearchCellHeight: CGFloat = 74.0
private let kPartyCellHeight: CGFloat = 102.0
private let kMainLabelLeftMargin: CGFloat = 22.0
private let kMainLabelTopMargin: CGFloat = 17.0
private let kMainLabelTextSize: CGFloat = 24.0
private let kMainLabelHeight: CGFloat = 30.0
private let kTableViewTopMargin: CGFloat = 25.0

class MainContentContainerView: UIView {
    
    enum State {
        case Search
        case Party
    }
    
    private var state: State = .Party
    
    var interactor: (ListBusinessesBusinessLogic & ListBusinessesDataStore)?
    var locationManager: CLLocationManager!
    
    private var searchTextField: TextField!
    private var tableView: MainTableView!
    private var profileButton: UIButton!
    private var mainLabel: UILabel!
    private var businesses: [ListBusinesses.FetchBusinesses.ViewModel.DisplayedBusiness] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMainLabel()
        setupSearchTextField()
        setupTableView()
    }
    
    func displayFetchedBusinesses(viewModel: ListBusinesses.FetchBusinesses.ViewModel) {
        self.businesses = viewModel.businesses
        self.tableView.reloadData()
    }
    
    private func setupMainLabel() {
        let frame = CGRect(x: kMainLabelLeftMargin, y: kMainLabelTopMargin, width: width(), height: kMainLabelHeight)
        mainLabel = UILabel(frame: frame)
        mainLabel.text = "Lunch Party"
        mainLabel.textAlignment = .left
        mainLabel.textColor = .appPurple()
        mainLabel.font = UIFont(name: "Chewy-Regular", size: kMainLabelTextSize)
        addSubview(mainLabel)
    }
    
    private func setupSearchTextField() {
        let width = self.width() - 2 * kSearchBarSideMargin
        searchTextField = TextField(frame: CGRect(x: kSearchBarSideMargin, y: mainLabel.maxY() + kSearchBarTopMargin, width: width, height: kSearchBarHeight))
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
        
        addSubview(searchTextField)
    }
    
    private func setupTableView() {
        let y = searchTextField.maxY() + kTableViewTopMargin
        let frame = CGRect(x: 0, y: y, width: width(), height: height() - y)
        tableView = MainTableView(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
    }
    
    @objc private func textFieldTextDidChange(_ textField: UITextField) {
        guard let searchTerm = textField.text else { return }
        if !searchTerm.isEmpty {
            state = .Search
            if let location = locationManager.location?.coordinate {
                let request = ListBusinesses.FetchBusinesses.Request(searchTerm: searchTerm, coordinates: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                interactor?.fetchBusinesses(request: request)
            }
        } else {
            state = .Party
        }
    }
    
}

extension MainContentContainerView: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.state == .Party {
            return kPartyCellHeight
        }
        return kSearchCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let businessId = businesses[indexPath.row].id
        guard let business = interactor?.businessesMap[businessId] else { return }
        let frame = CGRect(x: 0, y: 0, width: width(), height: height())
        let view = MainDetailContainerView(frame: frame)
        view.bind(business: business)
        self.addSubview(view)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchTextField.endEditing(true)
    }
    
}
