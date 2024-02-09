//
//  TrackersSupplementaryView.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 11.01.2024.
//

import Foundation
import UIKit

final class TrackersSupplementaryView: UICollectionReusableView {
    private enum Constant {
        static let baseFontSize: CGFloat = 19
        static let baseInset: CGFloat = 12
    }
    
    static let identifier = "TrackersSupplementaryView"
    
    // MARK: - UI
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.baseFontSize, weight: .bold)
        
        return label.forAutolayout()
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.placedOn(self)

        NSLayoutConstraint.activate([
            label.top.constraint(equalTo: top),
            label.left.constraint(equalTo: self.left, constant: Constant.baseInset),
            label.right.constraint(equalTo: self.right, constant: -Constant.baseInset),
            label.bottom.constraint(equalTo: bottom)
        ])
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public
    
    func configure(for model: TrackerCategory) {
        label.text = model.header
    }
}
