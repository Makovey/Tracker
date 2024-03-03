//
//  EmojiCell.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 08.02.2024.
//

import Foundation
import UIKit

final class EmojiCell: UICollectionViewCell {
    private enum Constant {
        static let baseCornerRadius: CGFloat = 16
        static let emojiSize: CGFloat = 32
    }
    
    var emoji: String? {
        didSet { emojiLabel.text = emoji }
    }

    override var isSelected: Bool {
        didSet {
            if oldValue { deselect() }
            else { didSelect() }
        }
    }

    // MARK: - UI
    
    private lazy var hoverBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constant.baseCornerRadius
        view.backgroundColor = Assets.primaryElementBackground.color.withAlphaComponent(1)
        view.isHidden = true
        
        return view.forAutolayout()
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.emojiSize, weight: .bold)
        
        return label.forAutolayout()
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public
    
    func configure(emoji: String) {
        self.emoji = emoji
    }
    
    func didSelect() {
        hoverBackground.isHidden = false
    }
    
    func deselect() {
        hoverBackground.isHidden = true
    }
    
    // MARK: - Private
    
    private func setupUI() {
        hoverBackground
            .placedOn(contentView)
            .pin(to: contentView)
        
        emojiLabel.placedOn(contentView)
        NSLayoutConstraint.activate([
            emojiLabel.centerX.constraint(equalTo: hoverBackground.centerX),
            emojiLabel.centerY.constraint(equalTo: hoverBackground.centerY),
        ])
    }
}
