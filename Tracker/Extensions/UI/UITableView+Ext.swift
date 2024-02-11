//
//  UITableView+Ext.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 08.02.2024.
//

import Foundation
import UIKit

extension UITableView {
    public func register<T: UITableViewCell>(_ cell: T.Type) {
        register(cell.self, forCellReuseIdentifier: T.identifier)
    }

    public func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }

        return cell
    }
}


extension UITableViewCell {
    var identifier: String {
        type(of: self).identifier
    }
        
    static var identifier: String {
        String(describing: self)
    }
}
