//
//  ViewController.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/14/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit

private let kLoginButtonBottomPadding: CGFloat = 14.0
private let kLoginButtonSidePadding: CGFloat = 28.0
private let kLoginButtonHeight: CGFloat = 52.0
private let kLoginButtonCornerRadius: CGFloat = 14.0
private let kLogoLabelHeight: CGFloat = 64.0
private let kLogoLabelTextSize: CGFloat = 48.0

class LoginViewController: UIViewController {
    
    var coordinator: MainCoordinator?
    private var safeArea: UIEdgeInsets?
    
    private var loginButton: ButtonWithIcon!
    private var logoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        safeArea = UIApplication.shared.windows.first?.safeAreaInsets

        setupLogoLabel()
        setupLoginWithSnapchatButton()
    }
    
    private func setupLogoLabel() {
        let frame = CGRect(x: 0, y: view.height() / 2 - kLogoLabelHeight / 2, width: view.width(), height: kLogoLabelHeight)
        logoLabel = UILabel(frame: frame)
        logoLabel.text = "Lunch Party"
        logoLabel.font = UIFont(name: "Chewy-Regular", size: kLogoLabelTextSize)
        logoLabel.textAlignment = .center
        logoLabel.textColor = .appPurple()
        view.addSubview(logoLabel)
    }
    
    private func setupLoginWithSnapchatButton() {
        let screenWidth = view.width()
        let width = screenWidth - kLoginButtonSidePadding * 2
        let frame = CGRect(x: kLoginButtonSidePadding, y: view.height() - kLoginButtonHeight - safeArea!.bottom - kLoginButtonBottomPadding, width: width, height: kLoginButtonHeight)
        let image = UIImage(named: "ghost")
        
        loginButton = ButtonWithIcon(frame: frame, image: image)
        loginButton.backgroundColor = .snapchatYellow()
        loginButton.setTitle("Login with Snapchat", for: .normal)
        loginButton.setTitleColor(UIColor.black, for: .normal)
        loginButton.titleLabel?.textAlignment = .center
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        loginButton.roundCorners(UIRectCorner.allCorners, radius: kLoginButtonCornerRadius)
        loginButton.dropShadow(color: UIColor.black, opacity: 0.15, offSet: CGSize(width: 4.0, height: 4.0), radius: kLoginButtonCornerRadius, scale: true)
        loginButton.addTarget(self, action: #selector(onSnapLoginButtonClicked), for: .touchUpInside)
        
        view.addSubview(loginButton)
    }
    
    @objc private func onSnapLoginButtonClicked() {
        coordinator?.loginWithSnapchat(from: self)
    }

}
