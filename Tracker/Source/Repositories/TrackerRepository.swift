//
//  TrackerCategoryRepository.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 05.02.2024.
//

import Foundation

enum TrackerCategoryRepositoryError: Error {
    case requiredDataIsMissing
}

protocol ITrackerRepository {
    func fetchAllCategories() -> [TrackerCategory]
    func fetchSelectedCategoryName() -> String?
    func saveSelectedCategoryName(_ categoryName: String)
    func saveAllCategories(_ categories: [String])
    func createTracker(_ tracker: Tracker) throws
    func replaceTracker(_ tracker: Tracker)

    func fetchRecords() -> [TrackerRecord]
    func save(record: TrackerRecord)
    func deleteRecordById(_ id: UUID)
    func deleteTrackerById(_ id: UUID)
}

final class TrackerRepository: ITrackerRepository {
    // MARK: - Properties
    
    private let storage: any IPersistenceStorage
    private var tempCategory: TrackerCategory?
        
    // MARK: - Lifecycle
    
    init(storage: some IPersistenceStorage) {
        self.storage = storage
    }
    
    // MARK: - Public
    
    func fetchAllCategories() -> [TrackerCategory] {
        storage.fetchCategories()
    }
    
    func fetchSelectedCategoryName() -> String? {
        tempCategory?.header
    }
    
    func saveSelectedCategoryName(_ categoryName: String) {
        let newCategory = TrackerCategory(header: categoryName, trackers: [])
        saveCategory(category: newCategory)
        tempCategory = newCategory
    }
    
    func saveAllCategories(_ categories: [String]) {
        categories.forEach {
            let newCategory = TrackerCategory(header: $0, trackers: [])
            saveCategory(category: newCategory)
        }
    }
 
    func createTracker(_ tracker: Tracker) throws {
        guard let tempCategory else {
            throw TrackerCategoryRepositoryError.requiredDataIsMissing
        }

        if let existedCategory = storage.fetchCategories().first(where: { $0.header == tempCategory.header }) {
            var tempTrackers = existedCategory.trackers
            tempTrackers.append(tracker)

            saveCategory(category: .init(header: existedCategory.header, trackers: tempTrackers))
        } else {
            storage.save(trackerCategory: .init(header: tempCategory.header, trackers: [tracker]))
        }

        flush()
    }

    func replaceTracker(_ tracker: Tracker) {
        guard let category = storage.fetchCategories().first(where: { $0.trackers.contains(where: { $0.id == tracker.id })}) else {
            assertionFailure("Can't find category for tracker \(tracker)")
            return
        }

        var newTrackers = category
            .trackers
            .filter { $0.id != tracker.id }

        newTrackers.append(tracker)

        storage.deleteTrackerById(tracker.id)
        saveCategory(category: .init(header: category.header, trackers: newTrackers))
    }

    func deleteTrackerById(_ id: UUID) {
        let recordIds = storage.fetchRecords().filter { $0.trackerId == id }.map { $0.trackerId }
        storage.deleteTrackerById(id)
        storage.deleteRecordsByTrackerIds(recordIds)
    }

    func fetchRecords() -> [TrackerRecord] {
        storage.fetchRecords()
    }
    
    func save(record: TrackerRecord) {
        storage.save(record: record)
    }
    
    func deleteRecordById(_ id: UUID) {
        storage.deleteRecordById(id)
    }
    
    // MARK: - Private
    
    private func saveCategory(
        category: TrackerCategory
    ) {
        if isCategoryAlreadyExisted(category) {
            if let existedCategory = findFirstExistedCategory(header: category.header), !category.trackers.isEmpty {
                let tempTrackers: Set<Tracker> = .init(existedCategory.trackers).union(category.trackers)
                
                storage.replaceCategory(
                    from: existedCategory,
                    to: .init(header: existedCategory.header, trackers: Array(tempTrackers))
                )
            }
        } else {
            storage.save(trackerCategory: category)
        }
    }
    
    private func isCategoryAlreadyExisted(_ category: TrackerCategory) -> Bool {
        storage.fetchCategories().contains(where: { $0.header == category.header })
    }
    
    private func findFirstExistedCategory(header: String) -> TrackerCategory? {
        storage.fetchCategories().first(where: { $0.header == header })
    }

    private func flush() {
        tempCategory = nil
    }
}
