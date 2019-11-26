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

private let kMapViewHeight: CGFloat = 120.0
private let kContainerViewTopMarginFromBottomOfMap: CGFloat = 40.0
private let kContainerViewCornerRadius: CGFloat = 14.0
private let kProfileSize: CGFloat = 40.0
private let kProfileTopMargin: CGFloat = 8.0
private let kProfileRightMargin: CGFloat = 15.0

protocol ListBusinessesDisplayLogic: class {
    func displayFetchedBusinesses(viewModel: ListBusinesses.FetchBusinesses.ViewModel)
    func displayFetchedBusiness(viewModel: ListBusinesses.FetchBusiness.ViewModel)
}

class MainViewController: UIViewController {
    
    private var interactor: (ListBusinessesBusinessLogic & ListBusinessesDataStore)?
    private var locationManager = CLLocationManager()
    
    private var mapView: GMSMapView!
    private var containerView: MainContentContainerView!
    private var profileButton: UIButton!
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
        containerView = MainContentContainerView(frame: frame)
        containerView.backgroundColor = .white
        containerView.roundCorners([.topLeft, .topRight], radius: kContainerViewCornerRadius)
        containerView.interactor = self.interactor
        containerView.locationManager = self.locationManager
        view.addSubview(containerView)
    }
    
}

extension MainViewController: ListBusinessesDisplayLogic {
    
    func displayFetchedBusinesses(viewModel: ListBusinesses.FetchBusinesses.ViewModel) {
        self.businesses = viewModel.businesses
        self.containerView.displayFetchedBusinesses(viewModel: viewModel)
    }
    
    func displayFetchedBusiness(viewModel: ListBusinesses.FetchBusiness.ViewModel) {
        
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
