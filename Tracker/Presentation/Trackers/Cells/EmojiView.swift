//
//  EmojiView.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 21.01.2024.
//

import Foundation
import UIKit

final class EmojiView: UIView {
    private enum Constant {
        static let fontSize: CGFloat = 12
    }
    
    // MARK: UI
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        
        return view.forAutolayout()
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.fontSize)
        
        return label.forAutolayout()
    }()
    
    // MARK: - Public
    
    func configure(emoji: String) {
        setupUI()
        emojiLabel.text = emoji
    }
    
    // MARK: - Private
    
    private func setupUI() {
        background
            .placedOn(self)
            .pin(to: self)
        
        emojiLabel.placedOn(background)
        NSLayoutConstraint.activate([
            emojiLabel.top.constraint(equalTo: background.top, constant: 1),
            emojiLabel.left.constraint(equalTo: background.left, constant: 4),
            emojiLabel.right.constraint(equalTo: background.right, constant: -4),
            emojiLabel.bottom.constraint(equalTo: background.bottom, constant: -1)
        ])
    }
}
