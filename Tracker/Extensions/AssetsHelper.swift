//
//  AssetsHelper.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

extension UIColor {
    static let primaryGreen = UIColor(named: "PrimaryGreen") ?? .init()
    static let primaryOrange = UIColor(named: "PrimaryOrange") ?? .init()
    static let primaryRed = UIColor(named: "PrimaryRed") ?? .init()
    static let primaryLightBlue = UIColor(named: "PrimaryLightBlue") ?? .init()
    static let primaryLightGreen = UIColor(named: "PrimaryLightGreen") ?? .init()
    static let transparent = UIColor(named: "Transparent") ?? .init()
    
    static let enabledState = UIColor(named: "EnabledState") ?? .init()
    static let canceledState = UIColor(named: "CanceledState") ?? .init()
    static let optionState = UIColor(named: "OptionState") ?? .init()

    static let primaryGray = UIColor(named: "PrimaryGray") ?? .init()
    static let primaryElementBackground = UIColor(named: "PrimaryElementBackground") ?? .init()
}

extension UIImage {
    static let emptyImage = UIImage(named: "EmptyTrackerImage") ?? .init()
    static let notFoundImage = UIImage(named: "NotFoundTrackerImage") ?? .init()
    static let chevron = UIImage(named: "Chevron") ?? .init()
}
