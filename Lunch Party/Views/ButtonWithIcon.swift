//
//  ButtonWithIcon.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/14/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit

private let kButtonLeftPadding: CGFloat = 16.0
private let kButtonImageWidth : CGFloat = 21.0

class ButtonWithIcon: UIButton {
    
    private let leftImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, image: UIImage?) {
        super.init(frame: frame)
        setImage(image: image)
    }
    
    func setImage(image: UIImage?) {
        if (image == nil) {
            return
        }
        leftImageView.frame = CGRect(x: kButtonLeftPadding, y: 0, width: kButtonImageWidth, height: frame.height)
        leftImageView.image = image
        leftImageView.contentMode = .scaleAspectFit
        addSubview(leftImageView)
    }
    
}
