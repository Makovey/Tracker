//
//  TrackerStore.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 15.02.2024.
//

import CoreData
import Foundation
import UIKit

protocol ITrackerStore {
    func fetchTrackers() throws -> [Tracker]
    func save(tracker: Tracker) throws
    func deleteById(_ id: UUID) throws
}

final class TrackerStore: ITrackerStore {
    private enum Constant {
        static let trackerEntityName = "TrackerCD"
        static let trackerId = "id"
    }
    
    // MARK: - Properties
    
    private let context: NSManagedObjectContext

    // MARK: - Lifecycle
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Public

    func fetchTrackers() throws -> [Tracker] {
        let request = NSFetchRequest<TrackerCD>(entityName: Constant.trackerEntityName)
        let trackers = try context.fetch(request)
        return trackers.map {
            Tracker(
                id: $0.id ?? .init(),
                name: $0.name ?? "",
                color: .init(hex: $0.color) ?? UIColor.clear,
                emoji: $0.emoji ?? "",
                schedule: $0.schedule as? Set<WeekDay>
            )
        }
    }
    
    func save(tracker: Tracker) throws {
        let trackerCD = TrackerCD(context: context)
        trackerCD.id = tracker.id
        trackerCD.name = tracker.name
        trackerCD.color = tracker.color.toHex()
        trackerCD.emoji = tracker.emoji
        trackerCD.schedule = tracker.schedule as? NSObject
        
        context.safeSave()
    }
    
    func deleteById(_ id: UUID) throws {
        let request = NSFetchRequest<TrackerCD>(entityName: Constant.trackerEntityName)
        request.predicate = NSPredicate(
            format: "\(Constant.trackerId) == %@",
            id as CVarArg
        )
        
        let trackers = try context.fetch(request)
        guard let tracker = trackers.first else { return }

        context.delete(tracker)
        context.safeSave()
    }
    
    
}
