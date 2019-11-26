//
//  MainDetailContainerView.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/19/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit

private let kBackButtonLeftPadding: CGFloat = 22.0
private let kBackButtonSize: CGFloat = 15.0
private let kBackButtonTopMargin: CGFloat = 7.0
private let kMainLabelLeftMargin: CGFloat = 22.0
private let kMainLabelTopMargin: CGFloat = 6.0
private let kMainLabelTextSize: CGFloat = 24.0
private let kMainLabelHeight: CGFloat = 30.0
private let kStickerTopMargin: CGFloat = 41.0
private let kStickerSideMargin: CGFloat = 39.0
private let kStickerHeight: CGFloat = 277.0
private let kScrollViewContentHeight: CGFloat = 710.0

class MainDetailContainerView: UIView {
    
    private var business: Business!
    
    private var scrollView: UIScrollView!
    private var containerView: UIView!
    private var stickerView: ShareStickerView!
    private var mainLabel: UILabel!
    private var backButton: UIButton!
    
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
        let frame = CGRect(x: kStickerSideMargin, y: mainLabel.maxY() + kStickerTopMargin, width: width, height: kStickerHeight)
        stickerView = ShareStickerView(frame: frame)
        containerView.addSubview(stickerView)
    }
    
    func bind(business: Business) {
        self.business = business
        stickerView.bind(business: business)
    }
    
    @objc private func onBackButtonClicked() {
        removeFromSuperview()
    }
    
}
