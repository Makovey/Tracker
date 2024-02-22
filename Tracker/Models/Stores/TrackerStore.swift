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
