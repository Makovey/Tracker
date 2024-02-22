//
//  EventsBuilderLayoutProvider.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 08.02.2024.
//

import Foundation
import UIKit

struct EventsBuilderLayoutProvider: ILayoutProvider {
    private enum Constant {
        static let baseInset: CGFloat = 18
        static let topInset: CGFloat = 12
        static let cellSpacing: CGFloat = 5
        static let estimatedSupplementaryHeight: CGFloat = 18
        static let absoluteItemHeight: CGFloat = 52
    }
    
    // MARK: - Public
    
    func layout() -> UICollectionViewCompositionalLayout {
        let section = makeSection()
        return .init(section: section)
    }
    
    // MARK: - Private
    
    private func makeHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize (
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constant.estimatedSupplementaryHeight)
        )
        
        return .init(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
    
    private func makeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constant.absoluteItemHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(10)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 6
        )
        
        group.interItemSpacing = .fixed(Constant.cellSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: Constant.topInset,
            leading: Constant.baseInset,
            bottom: Constant.baseInset,
            trailing: Constant.baseInset
        )
        section.boundarySupplementaryItems = [makeHeader()]
        
        return section
    }
}

