//
//  TrackersCell.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 11.01.2024.
//

import Foundation
import UIKit

final class TrackersCell: UICollectionViewCell {
    static let identifier = "TrackersCell"
    
    // MARK: UI
    
    private lazy var label: UILabel = {
        let label = UILabel()
        
        return label.forAutolayout()
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        
        label.placedOn(contentView)
        label.pin(to: contentView, inset: 2)
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public
    
    func configure(for model: Tracker) {
        backgroundColor = model.color
        label.text = model.name
    }
}
