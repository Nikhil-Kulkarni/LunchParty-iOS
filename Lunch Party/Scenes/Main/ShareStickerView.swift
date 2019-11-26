//
//  MainDetailView.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/20/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit

private let kContainerCornerRadius: CGFloat = 10.0
private let kProfileSize: CGFloat = 65.0
private let kTitleFieldTopPadding: CGFloat = 12.0
private let kTitleFieldTextSize: CGFloat = 24.0
private let kTitleFieldHeight: CGFloat = 28.0
private let kSubtitleFieldTopPadding: CGFloat = 11.0
private let kSubtitleFieldTextSize: CGFloat = 16.0
private let kSubtitleFieldHeight: CGFloat = 18.0
private let kImageSidePadding: CGFloat = 30.0
private let kImageCornerRadius: CGFloat = 6.0
private let kImageTopPadding: CGFloat = 23.0
private let kImageHeight: CGFloat = 94.0
private let kCaretTopPadding: CGFloat = 15.0
private let kCaretSize: CGFloat = 16.0
private let kSwipeUpTextSize: CGFloat = 12.0
private let kSwipeUpTextHeight: CGFloat = 16.0
private let kSwipeUpTextTopPadding: CGFloat = 2.0

class ShareStickerView: UIView {
    
    private let profileImageUrl = UserStore.sharedInstance.profileImageUrl
    
    private var containerView: UIView!
    private var profileImageView: UIImageView!
    private var titleTextField: UITextField!
    private var subtitleLabel: UILabel!
    private var thumbnail: UIImageView!
    private var upArrow: UIImageView!
    private var swipeUpLabel: UILabel!
    private var business: Business?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupContainerView()
        setupProfileImage()
        setupTitleField()
        setupSubtitleLabel()
        setupThumbnailImage()
        setupSwipeArrow()
        setupSwipeUpLabel()
    }
    
    func bind(business: Business) {
        self.business = business
        if let name = business.name {
            titleTextField.text = "Eat @\(name)?"
        }
        subtitleLabel.text = business.price
        
        if let imageUrl = business.imageUrl {
            thumbnail.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
    }
    
    private func setupContainerView() {
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: width(), height: height()))
        containerView.backgroundColor = .white
        containerView.roundCorners(.allCorners, radius: kContainerCornerRadius)
        containerView.dropShadow(color: UIColor.black, opacity: 0.15, offSet: CGSize(width: 4.0, height: 4.0), radius: kContainerCornerRadius, scale: true)
        addSubview(containerView)
    }
    
    private func setupProfileImage() {
        let frame = CGRect(x: width() / 2 - kProfileSize / 2, y: -kProfileSize / 2, width: kProfileSize, height: kProfileSize)
        profileImageView = UIImageView(frame: frame)
        guard let url = profileImageUrl else { return }
        profileImageView.sd_setImage(with: URL(string: url), completed: nil)
        containerView.addSubview(profileImageView)
    }
    
    private func setupTitleField() {
        let frame = CGRect(x: 0, y: profileImageView.maxY() + kTitleFieldTopPadding, width: containerView.width(), height: kTitleFieldHeight)
        titleTextField = UITextField(frame: frame)
        titleTextField.backgroundColor = .clear
        titleTextField.borderStyle = .none
        titleTextField.textAlignment = .center
        titleTextField.textColor = .black
        titleTextField.font = UIFont.boldSystemFont(ofSize: kTitleFieldTextSize)
        titleTextField.adjustsFontSizeToFitWidth = true
        containerView.addSubview(titleTextField)
    }
    
    private func setupSubtitleLabel() {
        let frame = CGRect(x: 0, y: titleTextField.maxY() + kSubtitleFieldTopPadding, width: containerView.width(), height: kSubtitleFieldHeight)
        subtitleLabel = UILabel(frame: frame)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .appYellow()
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: kSubtitleFieldTextSize)
        containerView.addSubview(subtitleLabel)
    }
    
    private func setupThumbnailImage() {
        let width = containerView.width() - kImageSidePadding * 2.0
        let frame = CGRect(x: kImageSidePadding, y: subtitleLabel.maxY() + kImageTopPadding, width: width, height: kImageHeight)
        thumbnail = UIImageView(frame: frame)
        thumbnail.roundCorners(.allCorners, radius: kImageCornerRadius)
        containerView.addSubview(thumbnail)
    }
    
    private func setupSwipeArrow() {
        let frame = CGRect(x: containerView.width() / 2 - kCaretSize / 2, y: thumbnail.maxY() + kCaretTopPadding, width: kCaretSize, height: kCaretSize)
        upArrow = UIImageView(frame: frame)
        upArrow.image = UIImage(named: "upArrow")
        containerView.addSubview(upArrow)
    }
    
    private func setupSwipeUpLabel() {
        let frame = CGRect(x: 0, y: upArrow.maxY() + kSwipeUpTextTopPadding, width: containerView.width(), height: kSwipeUpTextHeight)
        swipeUpLabel = UILabel(frame: frame)
        swipeUpLabel.textAlignment = .center
        swipeUpLabel.textColor = .black
        swipeUpLabel.font = UIFont.boldSystemFont(ofSize: kSwipeUpTextSize)
        swipeUpLabel.text = "Swipe up to RSVP"
        containerView.addSubview(swipeUpLabel)
    }
    
}
