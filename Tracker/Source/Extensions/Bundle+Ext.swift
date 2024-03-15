//
//  Bundle+Ext.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 03.03.2024.
//

import Foundation

extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}
