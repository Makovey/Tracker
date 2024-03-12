//
//  FilterType.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 11.03.2024.
//

import Foundation

enum FilterType: CaseIterable {
    case all, today, completed, inProgress

    var title: String {
        switch self {
        case .all: return .loc.Filters.All.title
        case .today: return .loc.Filters.Todays.title
        case .completed: return .loc.Filters.Ended.title
        case .inProgress: return .loc.Filters.InProgress.title
        }
    }
}
