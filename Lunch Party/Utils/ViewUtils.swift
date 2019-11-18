//
//  ViewUtils.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/15/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit

extension UIView {
    
    func height() -> CGFloat {
        return frame.height
    }
    
    func width() -> CGFloat {
        return frame.width
    }
    
    func x() -> CGFloat {
        return frame.origin.x
    }
    
    func y() -> CGFloat {
        return frame.origin.y
    }
    
    func maxX() -> CGFloat {
        return frame.maxX
    }
    
    func minX() -> CGFloat {
        return frame.minX
    }
    
    func maxY() -> CGFloat {
        return frame.maxY
    }
    
    func minY() -> CGFloat {
        return frame.minY
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func roundCornersDeprecated(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func toImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image(actions: { (context) in
            layer.render(in: context.cgContext)
        })
    }
    
}
