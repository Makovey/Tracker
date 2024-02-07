//
//  WeekDay.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 30.01.2024.
//

import Foundation

enum WeekDay: Int, CaseIterable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
        
    var label: String {
        switch self {
        case .monday:
            return "weekday.monday.title".localized
        case .tuesday:
            return "weekday.tuesday.title".localized
        case .wednesday:
            return "weekday.wednesday.title".localized
        case .thursday:
            return "weekday.thursday.title".localized
        case .friday:
            return "weekday.friday.title".localized
        case .saturday:
            return "weekday.saturday.title".localized
        case .sunday:
            return "weekday.sunday.title".localized
        }
    }
    
    var shortLabel: String {
        switch self {
        case .monday:
            return "weekday.monday.shortTitle".localized
        case .tuesday:
            return "weekday.tuesday.shortTitle".localized
        case .wednesday:
            return "weekday.wednesday.shortTitle".localized
        case .thursday:
            return "weekday.thursday.shortTitle".localized
        case .friday:
            return "weekday.friday.shortTitle".localized
        case .saturday:
            return "weekday.saturday.shortTitle".localized
        case .sunday:
            return "weekday.sunday.shortTitle".localized
        }
    }
    
    var dayInt: Int {
        switch self {
        case .monday:
            2
        case .tuesday:
            3
        case .wednesday:
            4
        case .thursday:
            5
        case .friday:
            6
        case .saturday:
            7
        case .sunday:
            1
        }
    }
}
