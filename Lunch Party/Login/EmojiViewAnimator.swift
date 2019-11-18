//
//  EmojiViewAnimator.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/15/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit

private let kAnimationDuration: TimeInterval = 4.0
private let kNumberOfEmojis = 8
private let kEmojiSize: CGFloat = 45.0

class EmojiViewAnimator {
    
    private var view: UIView!
    private var emojiViews: [UIView] = []
    
    init(view: UIView) {
        self.view = view
        
        for _ in 0...8 {
            let randomX = CGFloat.random(in: -(kEmojiSize / 2)..<self.view.width() + kEmojiSize / 2)
            let imageView = UIImageView(frame: CGRect(x: randomX, y: 0, width: kEmojiSize, height: kEmojiSize))
            imageView.image = UIImage(named: "hungryEmoji")
            emojiViews.append(imageView)
            view.addSubview(imageView)
        }
    }
    
    func start() {
        UIView.animate(withDuration: kAnimationDuration, delay: kAnimationDuration, options: .repeat, animations: {
            for emoji in self.emojiViews {
                emoji.frame = CGRect(x: emoji.x(), y: self.view.height(), width: emoji.width(), height: emoji.height())
            }
        }) { (done) in
            for emoji in self.emojiViews {
                let randomX = CGFloat.random(in: -(kEmojiSize / 2)..<self.view.width() + kEmojiSize / 2)
                emoji.frame = CGRect(x: randomX, y: 0.0, width: emoji.width(), height: emoji.height())
            }
        }
    }
    
}
