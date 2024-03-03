//
//  WeekDay.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 30.01.2024.
//

import Foundation

enum WeekDay: Int, CaseIterable, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
        
    var label: String {
        switch self {
        case .monday:
            return .loc.Weekday.Monday.title
        case .tuesday:
            return .loc.Weekday.Tuesday.title
        case .wednesday:
            return .loc.Weekday.Wednesday.title
        case .thursday:
            return .loc.Weekday.Thursday.title
        case .friday:
            return .loc.Weekday.Friday.title
        case .saturday:
            return .loc.Weekday.Saturday.title
        case .sunday:
            return .loc.Weekday.Sunday.title
        }
    }
    
    var shortLabel: String {
        switch self {
        case .monday:
            return .loc.Weekday.Monday.shortTitle
        case .tuesday:
            return .loc.Weekday.Tuesday.shortTitle
        case .wednesday:
            return .loc.Weekday.Wednesday.shortTitle
        case .thursday:
            return .loc.Weekday.Thursday.shortTitle
        case .friday:
            return .loc.Weekday.Friday.shortTitle
        case .saturday:
            return .loc.Weekday.Saturday.shortTitle
        case .sunday:
            return .loc.Weekday.Sunday.shortTitle
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
