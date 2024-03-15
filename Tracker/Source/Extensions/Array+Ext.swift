//
//  Array+Ext.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 12.03.2024.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
