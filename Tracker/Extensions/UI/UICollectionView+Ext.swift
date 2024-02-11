//
//  UICollectionViewCell+Ext.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 08.02.2024.
//

import Foundation
import UIKit

extension UICollectionView {
    public func register<T: UICollectionViewCell>(_ cell: T.Type) {
        register(cell, forCellWithReuseIdentifier: T.identifier)
    }

    public func register<T: UICollectionReusableView>(_ supplementary: T.Type, of kind: String) {
        register(supplementary, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.supplementaryIdentifier)
    }

    public func dequeueSupplementary<T: UICollectionReusableView>(
        kind: String,
        for indexPath: IndexPath
    ) -> T {
        let supplementary = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: T.supplementaryIdentifier,
            for: indexPath
        ) as? T

        guard let supplementary = supplementary else {
            fatalError("Could not dequeue supplementary view with identifier: \(T.supplementaryIdentifier) and kind: \(kind)")
        }
        return supplementary
    }

    public func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }

        return cell
    }
}


extension UICollectionViewCell {
    var identifier: String {
        type(of: self).identifier
    }
        
    static var identifier: String {
        String(describing: self)
    }
}

extension UICollectionReusableView {
    var supplementaryIdentifier: String {
        type(of: self).supplementaryIdentifier
    }
        
    static var supplementaryIdentifier: String {
        String(describing: self)
    }
}
