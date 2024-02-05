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
            return "Понедельник" // TODO: Localization
        case .tuesday:
            return "Вторник" // TODO: Localization
        case .wednesday:
            return "Среда" // TODO: Localization
        case .thursday:
            return "Четверг" // TODO: Localization
        case .friday:
            return "Пятница" // TODO: Localization
        case .saturday:
            return "Суббота" // TODO: Localization
        case .sunday:
            return "Воскресенье" // TODO: Localization
        }
    }
    
    var shortLabel: String {
        switch self {
        case .monday:
            return "Пн" // TODO: Localization
        case .tuesday:
            return "Вт" // TODO: Localization
        case .wednesday:
            return "Ср" // TODO: Localization
        case .thursday:
            return "Чт" // TODO: Localization
        case .friday:
            return "Пт" // TODO: Localization
        case .saturday:
            return "Сб" // TODO: Localization
        case .sunday:
            return "Вс" // TODO: Localization
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
