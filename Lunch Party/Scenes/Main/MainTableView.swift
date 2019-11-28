//
//  MainTableView.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/18/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit

private let kActivityIndicatorSize: CGFloat = 60.0

class MainTableView: UITableView {
    
    static let businessCellReuseIdentifier = "BusinessCellReuseIdentifier"
    
    private var activityIndicator: UIActivityIndicatorView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        separatorStyle = .none
        backgroundColor = .white
        showsHorizontalScrollIndicator = false
        
        register(BusinessTableViewCell.self, forCellReuseIdentifier: MainTableView.businessCellReuseIdentifier)
        let frame = CGRect(x: width() / 2 - kActivityIndicatorSize / 2, y: height() / 2 - kActivityIndicatorSize / 2, width: kActivityIndicatorSize, height: kActivityIndicatorSize)
        activityIndicator = UIActivityIndicatorView(frame: frame)
        activityIndicator.color = .appGray()
        activityIndicator.isHidden = true
        addSubview(activityIndicator)
    }
    
    func startLoadingAnimation() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func stopLoadingAnimation() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
}
