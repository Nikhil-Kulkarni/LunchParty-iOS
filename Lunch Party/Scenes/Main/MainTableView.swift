//
//  MainTableView.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/18/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class MainTableView: UITableView {
    
    static let businessCellReuseIdentifier = "BusinessCellReuseIdentifier"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        separatorStyle = .none
        
        register(BusinessTableViewCell.self, forCellReuseIdentifier: MainTableView.businessCellReuseIdentifier)
    }
    
}
