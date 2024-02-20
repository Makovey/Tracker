//
//  WeekDayTransformer.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 19.02.2024.
//

import Foundation

@objc
final class WeekDayTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            WeekDayTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: WeekDayTransformer.self))
        )
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? Set<WeekDay> else { return nil }
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode(Set<WeekDay>.self, from: data as Data)
    }
}
