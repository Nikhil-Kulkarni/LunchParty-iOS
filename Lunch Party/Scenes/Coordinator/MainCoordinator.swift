//
//  MainCoordinator.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/14/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import SCSDKLoginKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    private var userStore = UserStore.sharedInstance
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = LogoViewController()
        navigationController.pushViewController(vc, animated: false)
        SCUtils.fetchSCUserData { (success, userId, bitmojiAvatarUrl, displayName) in
            DispatchQueue.main.async {
                if (success) {
                    self.userStore.setUserProfile(id: userId!, profileImageUrl: bitmojiAvatarUrl, displayName: displayName)
                    self.presentMainPage()
                } else {
                    self.presentLoginPage()
                }
            }
        }
    }
    
    func loginWithSnapchat(from viewController: UIViewController) {
        SCSDKLoginClient.login(from: viewController) { (success, error) in
            if (success) {
                SCUtils.fetchSCUserData { (success, userId, bitmojiAvatarUrl, displayName) in
                    DispatchQueue.main.async {
                        if (success) {
                            self.userStore.setUserProfile(id: userId!, profileImageUrl: bitmojiAvatarUrl, displayName: displayName)
                            self.presentMainPage()
                        }
                    }
                }
            }
        }
    }
    
    private func presentLoginPage() {
        let vc = LoginViewController()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: false)
        self.navigationController.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func presentMainPage() {
        let vc = MainViewController()
        self.navigationController.pushViewController(vc, animated: false)
        self.navigationController.interactivePopGestureRecognizer?.isEnabled = false
    }
    
}
