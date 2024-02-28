//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 15.02.2024.
//

import CoreData
import Foundation

protocol ITrackerRecordStore {
    func fetchRecords() throws -> [TrackerRecord]
    func save(record: TrackerRecord) throws
    func deleteById(_ id: UUID) throws
}

final class TrackerRecordStore: ITrackerRecordStore {
    private enum Constant {
        static let recordEntityName = "TrackerRecordCD"
        static let recordId = "id"
    }
    // MARK: - Properties

    private let context: NSManagedObjectContext
    
    // MARK: - Lifecycle

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Public
    
    func fetchRecords() throws -> [TrackerRecord]  {
        let request = NSFetchRequest<TrackerRecordCD>(entityName: Constant.recordEntityName)
        let records = try context.fetch(request)
        return records.map {
            TrackerRecord(
                id: $0.id ?? UUID(),
                trackerId: $0.trackerId ?? UUID(),
                endDate: $0.endDate ?? Date()
            )
        }
    }

    func save(record: TrackerRecord) throws {
        let trackerRecord = TrackerRecordCD(context: context)

        trackerRecord.id = record.id
        trackerRecord.trackerId = record.trackerId
        trackerRecord.endDate = record.endDate

        context.safeSave()
    }
    
    func deleteById(_ id: UUID) throws {
        let request = NSFetchRequest<TrackerRecordCD>(entityName: Constant.recordEntityName)
        request.predicate = NSPredicate(
            format: "\(Constant.recordId) == %@",
            id as CVarArg
        )
        
        let records = try context.fetch(request)
        guard let record = records.first else { return }

        context.delete(record)
        context.safeSave()
    }
}
