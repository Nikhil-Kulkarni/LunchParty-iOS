//
//  LogoViewController.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/16/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit

private let kLogoLabelHeight: CGFloat = 64.0
private let kLogoLabelTextSize: CGFloat = 48.0

class LogoViewController: UIViewController {
    
    private var logoLabel: UILabel!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        let frame = CGRect(x: 0, y: view.height() / 2 - kLogoLabelHeight / 2, width: view.width(), height: kLogoLabelHeight)
        logoLabel = UILabel(frame: frame)
        logoLabel.textColor = .appPurple()
        logoLabel.font = UIFont(name: "Chewy-Regular", size: kLogoLabelTextSize)
        logoLabel.text = "Lunch Party"
        logoLabel.textAlignment = .center
        view.addSubview(logoLabel)
    }
    
}
