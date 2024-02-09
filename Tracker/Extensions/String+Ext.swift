//
//  String+Ext.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.02.2024.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
