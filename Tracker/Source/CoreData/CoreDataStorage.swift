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
    func deleteRecordsByTrackerIds(_ ids: [UUID])
    func deleteTrackerById(_ id: UUID)

    func fetchCategories() -> [TrackerCategory]
    func save(trackerCategory: TrackerCategory)
    func replaceCategory(from existedCategory: TrackerCategory, to category: TrackerCategory)
}

final class CoreDataStorage: IPersistenceStorage {
    private enum Constant {
        static let modelName = "TrackerModel"
    }

    // MARK: - Properties
    
    private lazy var trackerRecordStore: ITrackerRecordStore = TrackerRecordStore(context: context)
    private lazy var trackerCategoryStore: ITrackerCategoryStore = TrackerCategoryStore(context: context)
    private lazy var trackerStore: ITrackerStore = TrackerStore(context: context)
    
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

    func deleteRecordsByTrackerIds(_ ids: [UUID]) {
        do {
            try ids.forEach{ try trackerRecordStore.deleteByTrackerId($0) }
        } catch {
            assertionFailure("Can't delete records with -> \(ids) cause: \(error)")
        }
    }

    func deleteTrackerById(_ id: UUID) {
        do {
            try trackerStore.deleteById(id)
        } catch {
            assertionFailure("Can't delete tracker with -> \(id) cause: \(error)")
        }
    }

    func fetchCategories() -> [TrackerCategory] {
        do {
            return try trackerCategoryStore.fetchCategories().sorted(by: { $0.header < $1.header })
        } catch {
            assertionFailure("Can't fetch categories cause: \(error)")
        }
        
        return []
    }
    
    func save(trackerCategory: TrackerCategory) {
        do {
            try trackerCategoryStore.save(trackerCategory: trackerCategory)
        } catch {
            assertionFailure("Can't save category -> \(trackerCategory) cause: \(error)")
        }
    }
    
    func replaceCategory(from existedCategory: TrackerCategory, to category: TrackerCategory) {
        do {
            try existedCategory.trackers.forEach {
                try trackerStore.deleteById($0.id)
            }
            try trackerCategoryStore.deleteCategoryByName(existedCategory.header)
            try trackerCategoryStore.save(trackerCategory: category)
        } catch {
            assertionFailure("Can't replace category with -> \(existedCategory.header) cause: \(error)")
        }
    }
}
