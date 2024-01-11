//
//  TrackersSupplementaryView.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 11.01.2024.
//

import Foundation
import UIKit

final class TrackersSupplementaryView: UICollectionReusableView {
    static let identifier = "TrackersSupplementaryView"
    
    // MARK: - UI
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        
        return label.forAutolayout()
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.placedOn(self)
        label.pin(to: self, inset: 2)
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public
    
    func configure(for model: TrackerCategory) {
        label.text = model.header
    }
}
