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

protocol ITrackerCategoryRepository {
    func fetchCategories() -> [TrackerCategory]
    func fetchSelectedCategoryName() -> String?
    func saveSelectedCategoryName(_ categoryName: String)
    func saveAllCategories(_ categories: [String])
    func createTracker(_ tracker: Tracker) throws
    
    func fetchRecords() -> [TrackerRecord]
    func save(record: TrackerRecord)
    func deleteRecordById(_ id: UUID)
}

final class TrackerCategoryRepository: ITrackerCategoryRepository {
    
    // MARK: - Properties
    
    private let storage: any IPersistenceStorage
    private var tempCategory: TrackerCategory?
        
    // MARK: - Lifecycle
    
    init(storage: some IPersistenceStorage) {
        self.storage = storage
    }
    
    // MARK: - Public
    
    func fetchCategories() -> [TrackerCategory] {
        storage.fetchCategories()
    }
    
    func fetchSelectedCategoryName() -> String? {
        tempCategory?.header
    }
    
    func saveSelectedCategoryName(_ categoryName: String) {
        let newCategory = TrackerCategory(header: categoryName, trackers: [])
        saveExistedCategory(category: newCategory)
        tempCategory = newCategory
    }
    
    func saveAllCategories(_ categories: [String]) {
        categories.forEach {
            let newCategory = TrackerCategory(header: $0, trackers: [])
            saveExistedCategory(category: newCategory)
        }
    }
 
    func createTracker(_ tracker: Tracker) throws {
        guard let tempCategory else {
            throw TrackerCategoryRepositoryError.requiredDataIsMissing
        }

        if let existedCategory = storage.fetchCategories().first(where: { $0.header == tempCategory.header }) {
            var tempTrackers = existedCategory.trackers
            tempTrackers.append(tracker)

            saveExistedCategory(category: .init(header: existedCategory.header, trackers: tempTrackers))
        } else {
            storage.save(trackerCategory: .init(header: tempCategory.header, trackers: [tracker]))
        }

        flush()
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
    
    private func saveExistedCategory(
        category: TrackerCategory
    ) {
        if isAlreadyHaveCategory(category) {
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
    
    private func isAlreadyHaveCategory(_ category: TrackerCategory) -> Bool {
        storage.fetchCategories().contains(where: { $0.header == category.header })
    }
    
    private func findFirstExistedCategory(header: String) -> TrackerCategory? {
        storage.fetchCategories().first(where: { $0.header == header })
    }

    private func flush() {
        tempCategory = nil
    }
}
