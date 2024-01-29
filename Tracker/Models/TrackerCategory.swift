//
//  TrackerCategory.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 10.01.2024.
//

import Foundation

struct TrackerCategory: Hashable {
    let header: String
    let trackers: [Tracker]
    
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.header == rhs.header
    }
}
