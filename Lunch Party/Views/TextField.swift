//
//  SearchBar.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/17/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit

private let kTextFieldLeftMargin: CGFloat = 38.0
private let kTextFieldSearchIconSize: CGFloat = 17.0
private let kTextFieldSearchIconLeftMargin: CGFloat = 8.0
private let kTextFieldTextSize: CGFloat = 24.0
private let kTextFieldBorderRadius: CGFloat = 6.0

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: kTextFieldLeftMargin, bottom: 0, right: 5)
    
    override func layoutSubviews() {
        let rect = CGRect(x: kTextFieldSearchIconLeftMargin, y: frame.height / 2 - kTextFieldSearchIconSize / 2, width: kTextFieldSearchIconSize, height: kTextFieldSearchIconSize)
        let imageView = UIImageView(frame: rect)
        imageView.image = UIImage(named: "searchIcon")
        font = UIFont.boldSystemFont(ofSize: 24.0)
        attributedPlaceholder = NSAttributedString(string:"Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.appGray()])
        tintColor = .appPurple()
        textColor = .black
        addSubview(imageView)
        
        roundCorners(.allCorners, radius: kTextFieldBorderRadius)
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
