//
//  MainViewController.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/16/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import SDWebImage

private let kSearchBarHeight: CGFloat = 50.0
private let kSearchBarSideMargin: CGFloat = 22.0
private let kSearchBarTopMargin: CGFloat = 25.0
private let kSearchCellHeight: CGFloat = 74.0
private let kPartyCellHeight: CGFloat = 102.0
private let kMapViewHeight: CGFloat = 120.0
private let kContainerViewTopMarginFromBottomOfMap: CGFloat = 28.0
private let kContainerViewCornerRadius: CGFloat = 14.0
private let kMainLabelLeftMargin: CGFloat = 22.0
private let kMainLabelTopMargin: CGFloat = 17.0
private let kMainLabelTextSize: CGFloat = 24.0
private let kMainLabelHeight: CGFloat = 28.0
private let kTableViewTopMargin: CGFloat = 25.0
private let kProfileSize: CGFloat = 40.0
private let kProfileTopMargin: CGFloat = 8.0
private let kProfileRightMargin: CGFloat = 15.0

protocol ListBusinessesDisplayLogic: class {
    func displayFetchedBusinesses(viewModel: ListBusinesses.FetchBusinesses.ViewModel)
}

class MainViewController: UIViewController {
    
    enum State {
        case Search
        case Party
    }
    
    private var state: State = .Party
    private var interactor: (ListBusinessesBusinessLogic & ListBusinessesDataStore)?
    private var locationManager = CLLocationManager()
    
    private var searchTextField: TextField!
    private var tableView: MainTableView!
    private var mapView: GMSMapView!
    private var containerView: UIView!
    private var profileButton: UIButton!
    private var mainLabel: UILabel!
    private var businesses: [ListBusinesses.FetchBusinesses.ViewModel.DisplayedBusiness] = []
    
    private let userStore = UserStore.sharedInstance
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        setup()
        setupMapView()
        setupProfileIcon()
        setupContainerView()
        setupMainLabel()
        setupSearchTextField()
        setupTableView()
    }
    
    func updateMapCenter(coordinates: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition(latitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 14.0)
        mapView.camera = camera
    }
    
    private func setup() {
        let businessesInteractor = ListBusinessesInteractor()
        let presenter = ListBusinessesPresenter()
        self.interactor = businessesInteractor
        businessesInteractor.presenter = presenter
        presenter.viewController = self
    }
    
    private func setupMapView() {
        let camera = GMSCameraPosition(latitude: 0.0, longitude: 0.0, zoom: 14.0)
        let safeArea = UIApplication.shared.windows.first?.safeAreaInsets
        let frame = CGRect(x: 0, y: 0, width: view.width(), height: kMapViewHeight + safeArea!.top)
        mapView = GMSMapView.map(withFrame: frame, camera: camera)
        mapView.isUserInteractionEnabled = false
        do {
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
        } catch {
          print("One or more of the map styles failed to load")
        }
        view.addSubview(mapView)
        
        guard let location = locationManager.location else { return }
        let coordinate = location.coordinate
        let myCamera = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 14.0)
        mapView.camera = myCamera
    }
    
    private func setupProfileIcon() {
        let safeArea = UIApplication.shared.windows.first?.safeAreaInsets
        let frame = CGRect(x: view.width() - kProfileSize - kProfileRightMargin, y: safeArea!.top + kProfileTopMargin, width: kProfileSize, height: kProfileSize)
        profileButton = UIButton(frame: frame)
        profileButton.backgroundColor = .clear
        profileButton.roundCorners(.allCorners, radius: kProfileSize / 2)
        
        guard let url = userStore.profileImageUrl else { return }
        profileButton.sd_setImage(with: URL(string: url), for: .normal, completed: nil)
        view.addSubview(profileButton)
    }
    
    private func setupContainerView() {
        let y = mapView.maxY() - kContainerViewTopMarginFromBottomOfMap
        let frame = CGRect(x: 0, y: y, width: view.width(), height: view.height() - y)
        containerView = UIView(frame: frame)
        containerView.backgroundColor = .white
        containerView.roundCorners([.topLeft, .topRight], radius: kContainerViewCornerRadius)
        view.addSubview(containerView)
    }
    
    private func setupMainLabel() {
        let frame = CGRect(x: kMainLabelLeftMargin, y: kMainLabelTopMargin, width: containerView.width(), height: kMainLabelHeight)
        mainLabel = UILabel(frame: frame)
        mainLabel.text = "Lunch Party"
        mainLabel.textAlignment = .left
        mainLabel.textColor = .black
        mainLabel.font = UIFont.boldSystemFont(ofSize: kMainLabelTextSize)
        containerView.addSubview(mainLabel)
    }
    
    private func setupSearchTextField() {
        let width = containerView.width() - 2 * kSearchBarSideMargin
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
        
        containerView.addSubview(searchTextField)
    }
    
    private func setupTableView() {
        let y = searchTextField.maxY() + kTableViewTopMargin
        let frame = CGRect(x: 0, y: y, width: containerView.width(), height: containerView.height() - y)
        tableView = MainTableView(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        containerView.addSubview(tableView)
    }
    
    @objc private func textFieldTextDidChange(_ textField: UITextField) {
        guard let searchTerm = textField.text else { return }
        if !searchTerm.isEmpty {
            state = .Search
            let request = ListBusinesses.FetchBusinesses.Request(searchTerm: searchTerm, coordinates: CLLocationCoordinate2D(latitude: 34.061034, longitude: -118.442763))
            interactor?.fetchBusinesses(request: request)
        } else {
            state = .Party
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.state == .Party {
            return kPartyCellHeight
        }
        return kSearchCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = businesses[indexPath.row]
        // TODO
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchTextField.endEditing(true)
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            guard let location = manager.location else { return }
            DispatchQueue.main.async {
                self.updateMapCenter(coordinates: location.coordinate)
            }
        } else {
            // TODO: show alert
        }
    }
    
}
