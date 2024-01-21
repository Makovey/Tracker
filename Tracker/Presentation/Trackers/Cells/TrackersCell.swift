//
//  TrackersCell.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 11.01.2024.
//

import Foundation
import UIKit

final class TrackersCell: UICollectionViewCell {
    private enum Constant {
        static let backgroundCardHeight: CGFloat = 90
        static let addButtonSize: CGFloat = 34
        static let baseFontSize: CGFloat = 12
        static let baseInset: CGFloat = 12
        static let emojiSize: CGFloat = 24
    }

    static let identifier = "TrackersCell"
    
    // MARK: UI
    
    private lazy var backgroundCardView: UIView = {
        let background = UIView()
        background.layer.borderWidth = 1
        background.layer.borderColor = UIColor.cardBorder.cgColor
        background.layer.masksToBounds = true
        
        return background.forAutolayout()
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.baseFontSize)
        label.textColor = .systemBackground
        label.numberOfLines = 2

        return label.forAutolayout()
    }()
    
    private lazy var emojiView: EmojiView = {
        .init().forAutolayout()
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.baseFontSize)
        label.textColor = .label
        
        return label.forAutolayout()
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemBackground
        button.layer.cornerRadius = Constant.addButtonSize / 2
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        return button.forAutolayout()
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public
    
    func configure(for model: Tracker) {
        backgroundCardView.backgroundColor = model.color
        titleLabel.text = model.name
        dateLabel.text = "\(model.schedule.count) дней" // TODO: Localization
        addButton.backgroundColor = model.color
        emojiView.set(emoji: model.emoji)
    }
    
    // MARK: Private
    
    private func setupUI() {
        backgroundCardView.layer.cornerRadius = 16
        
        backgroundCardView.placedOn(contentView)
        NSLayoutConstraint.activate([
            backgroundCardView.top.constraint(equalTo: contentView.top),
            backgroundCardView.left.constraint(equalTo: contentView.left),
            backgroundCardView.right.constraint(equalTo: contentView.right),
            backgroundCardView.height.constraint(equalToConstant: Constant.backgroundCardHeight)
        ])
        
        titleLabel.placedOn(backgroundCardView)
        NSLayoutConstraint.activate([
            titleLabel.left.constraint(equalTo: backgroundCardView.left, constant: Constant.baseInset),
            titleLabel.right.constraint(equalTo: backgroundCardView.right, constant: -Constant.baseInset),
            titleLabel.bottom.constraint(equalTo: backgroundCardView.bottom, constant: -Constant.baseInset)
        ])
        
        emojiView.placedOn(backgroundCardView)
        NSLayoutConstraint.activate([
            emojiView.top.constraint(equalTo: backgroundCardView.top, constant: Constant.baseInset),
            emojiView.left.constraint(equalTo: backgroundCardView.left, constant: Constant.baseInset),
            emojiView.width.constraint(equalToConstant: Constant.emojiSize),
            emojiView.height.constraint(equalToConstant: Constant.emojiSize)
        ])
        
        dateLabel.placedOn(contentView)
        NSLayoutConstraint.activate([
            dateLabel.top.constraint(equalTo: backgroundCardView.bottom, constant: 16),
            dateLabel.left.constraint(equalTo: contentView.left, constant: Constant.baseInset)
        ])
        
        addButton.placedOn(contentView)
        NSLayoutConstraint.activate([
            addButton.top.constraint(equalTo: backgroundCardView.bottom, constant: 8),
            addButton.right.constraint(equalTo: contentView.right, constant: -Constant.baseInset),
            addButton.height.constraint(equalToConstant: Constant.addButtonSize),
            addButton.width.constraint(equalToConstant: Constant.addButtonSize),
        ])
    }
    
    @objc
    private func addButtonTapped() {
        print(#function)
    }
}
