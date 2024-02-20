//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 15.02.2024.
//

import CoreData
import Foundation
import UIKit

protocol ITrackerCategoryStore {
    func fetchCategories() throws -> [TrackerCategory]
    func save(trackerCategory: TrackerCategory) throws
    func deleteCategoryByName(_ name: String) throws
}

final class TrackerCategoryStore: ITrackerCategoryStore {
    private enum Constant {
        static let categoryEntityName = "TrackerCategoryCD"
        static let header = "header"
    }
    // MARK: - Properties

    private let context: NSManagedObjectContext
    
    // MARK: - Lifecycle

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchCategories() throws -> [TrackerCategory] {
        let request = NSFetchRequest<TrackerCategoryCD>(entityName: Constant.categoryEntityName)
        let categories = try context.fetch(request)
        return categories.map {
            TrackerCategory(
                header: $0.header ?? "",
                trackers: convert(from: $0.trackers)
            )
        }
    }
    
    func save(trackerCategory: TrackerCategory) throws {
        let category = TrackerCategoryCD(context: context)
        let trackersCD = trackerCategory
            .trackers
            .map {
                let trackerCD = TrackerCD(context: context)
                trackerCD.id = $0.id
                trackerCD.name = $0.name
                trackerCD.color = $0.color.toHex()
                trackerCD.emoji = $0.emoji
                trackerCD.schedule = $0.schedule as? NSObject
                return trackerCD
            }
        
        category.header = trackerCategory.header
        category.addToTrackers(NSSet(array: trackersCD))
        
        context.safeSave()
    }
    
    func deleteCategoryByName(_ name: String) throws {
        let request = NSFetchRequest<TrackerCategoryCD>(entityName: Constant.categoryEntityName)
        request.predicate = NSPredicate(
            format: "\(Constant.header) == %@",
            name as CVarArg
        )
        
        let categories = try context.fetch(request)
        guard let category = categories.first else { return }

        context.delete(category)
        context.safeSave()
    }
    
    private func convert(from trackersCDSet: NSSet?) -> [Tracker] {
        guard let trackersCDArray = trackersCDSet?.allObjects as? [TrackerCD] else {
            assertionFailure("Can't convert \(String(describing: trackersCDSet)) to [TrackerCD]")
            return []
        }
        
        return trackersCDArray.map {
            Tracker(
                id: $0.id ?? .init(),
                name: $0.name ?? "",
                color: .init(hex: $0.color) ?? UIColor.clear,
                emoji: $0.emoji ?? "",
                schedule: $0.schedule as? Set<WeekDay>
            )
        }
    }
}
