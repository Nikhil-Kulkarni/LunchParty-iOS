//
//  BusinessTableViewCell.swift
//  Lunch Party
//
//  Created by Nikhil Kulkarni on 11/18/19.
//  Copyright © 2019 Nikhil Kulkarni. All rights reserved.
//

import UIKit

private let kContentHeight: CGFloat = 60.0
private let kTitleLabelHeight: CGFloat = 28.0
private let kTitleLabelTextSize: CGFloat = 24.0
private let kSubtitleLabelHeight: CGFloat = 14.0
private let kSubtitleLabelTextSize: CGFloat = 12.0
private let kSubtitleLabelTopMargin: CGFloat = 5.0
private let kArrowSize: CGFloat = 19.0
private let kSideMargin: CGFloat = 21.0
private let kSeparatorBottomMargin: CGFloat = 14.0
private let kSeparatorHeight: CGFloat = 0.5

class BusinessTableViewCell: UITableViewCell {
    
    private var id: String!
    
    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    private var arrowImageView = UIImageView()
    private var separatorView = UIView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(separatorView)
    }
    
    override func layoutSubviews() {
        backgroundColor = .white
        selectionStyle = .none
        setupTitleLabel()
        setupSubtitleLabel()
        setupArrow()
        setupSeparator()
    }
    
    private func setupTitleLabel() {
        let frame = CGRect(x: kSideMargin, y: 0, width: contentView.width() * 0.75, height: kTitleLabelHeight)
        titleLabel.frame = frame
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: kTitleLabelTextSize)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
    }
    
    private func setupSubtitleLabel() {
        let frame = CGRect(x: kSideMargin, y: titleLabel.maxY() + kSubtitleLabelTopMargin, width: contentView.width(), height: kSubtitleLabelHeight)
        subtitleLabel.frame = frame
        subtitleLabel.font = UIFont.systemFont(ofSize: kSubtitleLabelTextSize)
        subtitleLabel.textColor = .appGray()
        subtitleLabel.textAlignment = .left
    }
    
    private func setupArrow() {
        let frame = CGRect(x: contentView.width() - kArrowSize - kSideMargin, y: kContentHeight / 2 - kArrowSize / 2, width: kArrowSize, height: kArrowSize)
        arrowImageView.frame = frame
        arrowImageView.image = UIImage(named: "rightArrow")
    }
    
    private func setupSeparator() {
        let frame = CGRect(x: kSideMargin, y: contentView.height() - kSeparatorBottomMargin, width: contentView.width() - kSideMargin * 2, height: kSeparatorHeight)
        separatorView.frame = frame
        separatorView.backgroundColor = .appLightGray()
    }
    
    func bind(viewModel: ListBusinesses.FetchBusinesses.ViewModel.DisplayedBusiness) {
        id = viewModel.id
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
    
}
