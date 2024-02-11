//
//  ColorCell.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 09.02.2024.
//

import Foundation
import UIKit

final class ColorCell: UICollectionViewCell {
    private enum Constant {
        static let baseCornerRadius: CGFloat = 8
    }

    override var isSelected: Bool {
        didSet {
            if oldValue { deselect() }
            else { didSelect() }
        }
    }
    
    var mainColor: UIColor? {
        didSet { colorView.backgroundColor = mainColor }
    }
    private var borderColor: CGColor? {
        mainColor?.withAlphaComponent(0.3).cgColor ?? UIColor.gray.cgColor
    }
    
    // MARK: UI
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constant.baseCornerRadius
        
        return view.forAutolayout()
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public
    
    func configure(color: UIColor) {
        mainColor = color
        
        contentView.layer.borderColor = borderColor
    }
    
    func didSelect() {
        contentView.layer.borderWidth = 3
    }
    
    func deselect() {
        contentView.layer.borderWidth = 0
    }
    
    // MARK: - Private
    
    private func setupUI() {
        colorView
            .placedOn(contentView)
            .pin(to: contentView, inset: 6)
        
        contentView.layer.cornerRadius = Constant.baseCornerRadius
    }
}
