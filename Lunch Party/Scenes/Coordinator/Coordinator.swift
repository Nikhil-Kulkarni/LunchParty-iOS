//
//  Coordinator.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/14/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}
