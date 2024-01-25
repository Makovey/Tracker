//
//  AssetsHelper.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

extension UIColor {
    static let greenCard = UIColor(named: "GreenCard") ?? .init()
    static let orangeCard = UIColor(named: "OrangeCard") ?? .init()
    static let redCard = UIColor(named: "RedCard") ?? .init()
    static let lightBlueCard = UIColor(named: "LightBlueCard") ?? .init()
    static let lightGreenCard = UIColor(named: "LightGreenCard") ?? .init()
    static let cardBorder = UIColor(named: "CardBorder") ?? .init()
    
    static let enabledButton = UIColor(named: "EnabledState") ?? .init()
    static let disabledButton = UIColor(named: "DisabledState") ?? .init()
    static let canceledButton = UIColor(named: "CanceledState") ?? .init()
    static let optionButton = UIColor(named: "OptionState") ?? .init()
}

extension UIImage {
    static let emptyImage = UIImage(named: "EmptyTrackerImage") ?? .init()
}
