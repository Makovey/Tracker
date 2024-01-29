//
//  Tracker.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 10.01.2024.
//

import Foundation
import UIKit

struct Tracker: Hashable {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Date]
}
