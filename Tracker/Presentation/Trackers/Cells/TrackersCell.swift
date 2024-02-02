//
//  TrackersCell.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 11.01.2024.
//

import Foundation
import UIKit

protocol ITrackersCellDelegate: AnyObject {
    func doneButtonTapped(with id: UUID, state: Bool)
}

final class TrackersCell: UICollectionViewCell {
    private enum Constant {
        static let backgroundCardHeight: CGFloat = 90
        static let addButtonSize: CGFloat = 34
        static let baseFontSize: CGFloat = 12
        static let baseInset: CGFloat = 12
        static let emojiSize: CGFloat = 24
    }
    
    struct Model {
        let tracker: Tracker
        let isCompletedForToday: Bool
        let completedTimes: Int
        let isEditingAvailable: Bool
    }
    
    weak var delegate: (any ITrackersCellDelegate)?
    static let identifier = "TrackersCell"
    
    private var isButtonTapped = false
    private var id = UUID()
    private var completedDaysCounter = 0 {
        didSet {
            dateLabel.text = "\(completedDaysCounter) дней" // TODO: Localization
        }
    }
    
    // MARK: UI
    
    private lazy var backgroundCardView: UIView = {
        let background = UIView()
        background.layer.borderWidth = 1
        background.layer.borderColor = UIColor.transparent.cgColor
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
    
    func configure(with model: Model) {
        updateUI(model: model)
        
        completedDaysCounter = model.completedTimes
        id = model.tracker.id
        
        if model.isEditingAvailable {
            addButton.isEnabled = true
        }
        else { 
            addButton.isEnabled = false
        }
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
    
    private func updateUI(model: Model) {
        backgroundCardView.backgroundColor = model.tracker.color
        titleLabel.text = model.tracker.name
        addButton.backgroundColor = model.tracker.color
        emojiView.set(emoji: model.tracker.emoji)
        
        model.isCompletedForToday ? makeTappedButtonState() : makeNormalButtonState()
    }
    
    private func makeNormalButtonState() {
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.layer.opacity = 1.0
        isButtonTapped = false
    }
    
    private func makeTappedButtonState() {
        addButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        addButton.layer.opacity = 0.3
        isButtonTapped = true
    }
    
    @objc
    private func addButtonTapped() {
        if isButtonTapped {
            makeNormalButtonState()
            completedDaysCounter -= 1
        } else {
            makeTappedButtonState()
            completedDaysCounter += 1
        }
        
        delegate?.doneButtonTapped(with: id, state: isButtonTapped)
    }
}
