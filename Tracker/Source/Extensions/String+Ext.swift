//
//  String+Ext.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.02.2024.
//

import Foundation

extension String {
    typealias loc = Localization
}

extension String {
    static func completedDays(_ quantity: Int) -> Self {
        Self.localizedStringWithFormat(
            NSLocalizedString("completedDays", comment: "Number of completed days. Streak"),
            quantity
        )
    }
}
