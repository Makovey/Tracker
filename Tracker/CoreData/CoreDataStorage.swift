//
//  CoreDataStorage.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 12.02.2024.
//

import CoreData
import Foundation

protocol IPersistenceStorage {
    func fetchRecords() -> [TrackerRecord]
    func save(record: TrackerRecord)
    func deleteRecordById(_ id: UUID)
}

final class CoreDataStorage: IPersistenceStorage {
    private enum Constant {
        static let modelName = "TrackerModel"
    }

    // MARK: - Properties
    
    private lazy var trackerRecordStore: ITrackerRecordStore = TrackerRecordStore(context: context)
    
    private lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: Constant.modelName)
        container.loadPersistentStores { description, error in
            if let error = error as? NSError {
                assertionFailure("Can't load persistence stores cause: \(error)")
            }
        }
        
        return container.viewContext
    }()
    
    // MARK: - Public
    
    func fetchRecords() -> [TrackerRecord] {
        do {
            return try trackerRecordStore.fetchRecords()
        } catch {
            assertionFailure("Can't fetch records cause: \(error)")
        }
        
        return []
    }

    func save(record: TrackerRecord) {
        do {
            try trackerRecordStore.save(record: record)
        } catch {
            assertionFailure("Can't save record -> \(record) cause: \(error)")
        }
    }
    
    func deleteRecordById(_ id: UUID) {
        do {
            try trackerRecordStore.deleteById(id)
        } catch {
            assertionFailure("Can't delete record with -> \(id) cause: \(error)")
        }
    }

    // MARK: - Private
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
                context.rollback()
            }
        }
    }
}
