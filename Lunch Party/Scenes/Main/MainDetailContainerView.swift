//
//  MainDetailContainerView.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/19/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import SCSDKCreativeKit

private let kBackButtonLeftPadding: CGFloat = 22.0
private let kBackButtonSize: CGFloat = 15.0
private let kBackButtonTopMargin: CGFloat = 7.0
private let kMainLabelLeftMargin: CGFloat = 22.0
private let kMainLabelTopMargin: CGFloat = 6.0
private let kMainLabelTextSize: CGFloat = 24.0
private let kMainLabelHeight: CGFloat = 30.0
private let kStickerTopMargin: CGFloat = 8.0
private let kStickerSideMargin: CGFloat = 39.0
private let kStickerHeight: CGFloat = 277.0
private let kScrollViewContentHeight: CGFloat = 690.0
private let kShareButtonSideMargin: CGFloat = 28.0
private let kShareButtonHeight: CGFloat = 52.0
private let kShareButtonTopMargin: CGFloat = 38.0
private let kShareButtonTextSize: CGFloat = 16.0
private let kShareButtonCornerRadius: CGFloat = 10.0
private let kIconTopMargin: CGFloat = 35.0
private let kCopyLinkIconSize: CGFloat = 30.0
private let kCopyLinkLeftMargin: CGFloat = 28.0
private let kCopyLinkLabelHeight: CGFloat = 28.0
private let kCopyLinkLabelTextSize: CGFloat = 24.0
private let kCopyLinkLabelLeftMargin: CGFloat = 13.0
private let kSafariIconSize: CGFloat = 30.0
private let kSafariLabelHeight: CGFloat = 28.0
private let kSafariLabelTextSize: CGFloat = 24.0
private let kSafariLabelLeftMargin: CGFloat = 13.0
private let kShareIconSize: CGFloat = 30.0
private let kShareIconHeight: CGFloat = 28.0
private let kShareIconLabelTextSize: CGFloat = 24.0
private let kShareIconLabelLeftMargin: CGFloat = 13.0
private let kDividerHeight: CGFloat = 0.5
private let kDividerTopMargin: CGFloat = 23.0

class MainDetailContainerView: UIView {
    
    private var business: Business!
    
    private var scrollView: UIScrollView!
    private var containerView: UIView!
    private var stickerView: ShareStickerView!
    private var mainLabel: UILabel!
    private var backButton: UIButton!
    private var shareOnSnapchatButton: ButtonWithIcon!
    private var linkImageView: UIImageView!
    private var globeImageView: UIImageView!
    private var shareImageView: UIImageView!
    private var linkLabel: UILabel!
    private var safariLabel: UILabel!
    private var shareLabel: UILabel!
    
    private let snapAPI = SCSDKSnapAPI()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScrollView()
        setupContainerView()
        setupBackButton()
        setupMainLabel()
        setupStickerView()
        setupShareOnSnapchat()
        setupCopyLink()
        setupSafariLink()
        setupShareOptions()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame: self.frame)
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: self.width(), height: kScrollViewContentHeight)
        addSubview(scrollView)
    }
    
    private func setupContainerView() {
        let frame = CGRect(x: 0, y: 0, width: width(), height: kScrollViewContentHeight)
        containerView = UIView(frame: frame)
        containerView.backgroundColor = .clear
        scrollView.addSubview(containerView)
    }
    
    private func setupBackButton() {
        let frame = CGRect(x: kBackButtonLeftPadding, y: kBackButtonTopMargin, width: kBackButtonSize, height: kBackButtonSize)
        backButton = UIButton(frame: frame)
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.addTarget(self, action: #selector(onBackButtonClicked), for: .touchUpInside)
        containerView.addSubview(backButton)
    }
    
    private func setupMainLabel() {
        let frame = CGRect(x: kMainLabelLeftMargin, y: backButton.maxY() + kMainLabelTopMargin, width: width(), height: kMainLabelHeight)
        mainLabel = UILabel(frame: frame)
        mainLabel.text = "Lunch Party"
        mainLabel.textAlignment = .left
        mainLabel.textColor = .appPurple()
        mainLabel.font = UIFont(name: "Chewy-Regular", size: kMainLabelTextSize)
        containerView.addSubview(mainLabel)
    }
    
    private func setupStickerView() {
        let width = containerView.width() - 2 * kStickerSideMargin
        let frame = CGRect(x: kStickerSideMargin, y: mainLabel.maxY() + kStickerTopMargin, width: width, height: kStickerHeight + kStickerProfileSize / 2)
        stickerView = ShareStickerView(frame: frame)
        containerView.addSubview(stickerView)
    }
    
    private func setupShareOnSnapchat() {
        let width = containerView.width() - kShareButtonSideMargin * 2
        let frame = CGRect(x: kShareButtonSideMargin, y: stickerView.maxY() + kShareButtonTopMargin, width: width, height: kShareButtonHeight)
        let image = UIImage(named: "ghost")
        
        shareOnSnapchatButton = ButtonWithIcon(frame: frame, image: image)
        shareOnSnapchatButton.backgroundColor = .snapchatYellow()
        shareOnSnapchatButton.setTitle("Share on Snapchat", for: .normal)
        shareOnSnapchatButton.setTitleColor(UIColor.black, for: .normal)
        shareOnSnapchatButton.titleLabel?.textAlignment = .center
        shareOnSnapchatButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: kShareButtonTextSize)
        shareOnSnapchatButton.roundCorners(UIRectCorner.allCorners, radius: kShareButtonCornerRadius)
        shareOnSnapchatButton.dropShadow(color: UIColor.black, opacity: 0.15, offSet: CGSize(width: 4.0, height: 4.0), radius: kShareButtonCornerRadius, scale: true)
        shareOnSnapchatButton.addTarget(self, action: #selector(onShareToSnapButtonClicked), for: .touchUpInside)
        
        containerView.addSubview(shareOnSnapchatButton)
    }
    
    private func setupCopyLink() {
        let imageFrame = CGRect(x: kCopyLinkLeftMargin, y: shareOnSnapchatButton.maxY() + kIconTopMargin, width: kCopyLinkIconSize, height: kCopyLinkIconSize)
        linkImageView = UIImageView(frame: imageFrame)
        linkImageView.image = UIImage(named: "linkIcon")
        containerView.addSubview(linkImageView)
        
        let linkFrame = CGRect(x: linkImageView.maxX() + kCopyLinkLabelLeftMargin, y: linkImageView.y(), width: width(), height: kCopyLinkLabelHeight)
        linkLabel = UILabel(frame: linkFrame)
        linkLabel.text = "Copy Link"
        linkLabel.textColor = .black
        linkLabel.font = UIFont.boldSystemFont(ofSize: kCopyLinkLabelTextSize)
        containerView.addSubview(linkLabel)
    }
    
    private func setupSafariLink() {
        let imageFrame = CGRect(x: kCopyLinkLeftMargin, y: linkImageView.maxY() + kIconTopMargin, width: kSafariIconSize, height: kSafariIconSize)
        globeImageView = UIImageView(frame: imageFrame)
        globeImageView.image = UIImage(named: "globeIcon")
        containerView.addSubview(globeImageView)
        
        let linkFrame = CGRect(x: linkLabel.x(), y: globeImageView.y(), width: width(), height: kSafariLabelHeight)
        safariLabel = UILabel(frame: linkFrame)
        safariLabel.text = "Open in Safari"
        safariLabel.textColor = .black
        safariLabel.font = UIFont.boldSystemFont(ofSize: kSafariLabelTextSize)
        containerView.addSubview(safariLabel)
    }
    
    private func setupShareOptions() {
        let imageFrame = CGRect(x: kCopyLinkLeftMargin, y: globeImageView.maxY() + kIconTopMargin, width: kShareIconSize, height: kShareIconSize)
        shareImageView = UIImageView(frame: imageFrame)
        shareImageView.image = UIImage(named: "shareIcon")
        containerView.addSubview(shareImageView)
        
        let linkFrame = CGRect(x: linkLabel.x(), y: shareImageView.y(), width: width(), height: kSafariLabelHeight)
        shareLabel = UILabel(frame: linkFrame)
        shareLabel.text = "Other Share Options"
        shareLabel.textColor = .black
        shareLabel.font = UIFont.boldSystemFont(ofSize: kShareIconLabelTextSize)
        containerView.addSubview(shareLabel)
    }
    
    func bind(business: Business) {
        self.business = business
        stickerView.bind(business: business)
    }
    
    @objc private func onBackButtonClicked() {
        removeFromSuperview()
    }
    
    @objc private func onShareToSnapButtonClicked() {
        let sticker = SCSDKSnapSticker(stickerImage: stickerView.toImage())
        let snap = SCSDKNoSnapContent()
        snap.sticker = sticker
        
        DispatchQueue.main.async {
            self.snapAPI.startSending(snap) { (error) in
                print(error)
            }
        }
    }
    
    @objc private func onCopyLinkClicked() {
        
    }
    
    @objc private func onOtherShareOptionsClicked() {
        
    }
    
}
