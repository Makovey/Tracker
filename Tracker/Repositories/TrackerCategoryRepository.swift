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
    func createTracker(_ tracker: Tracker) throws
}

final class TrackerCategoryRepository: ITrackerCategoryRepository {
    static let shared = TrackerCategoryRepository()
    
    // MARK: - Private
    
    // with temp mock data
    private var categories: [TrackerCategory] = [
        .init(header: "Отдых", trackers: [
            .init(
                name: "Погулять",
                color: .primaryGreen,
                emoji: "🚶",
                schedule: [.sunday, .thursday]),
            .init(
                name: "Покататься на велосипеде",
                color: .primaryOrange,
                emoji: "🚴",
                schedule: [.saturday]),
            .init(
                name: "Почитать книгу",
                color: .primaryRed,
                emoji: "📙",
                schedule: [.friday, .wednesday])
        ]),
        .init(header: "Работа", trackers: [
            .init(
                name: "Закрыть задачу",
                color: .primaryLightBlue,
                emoji: "👷",
                schedule: [.monday])
        ]),
        .init(header: "Поездка", trackers: [
            .init(
                name: "Забронировать отель",
                color: .primaryLightGreen,
                emoji: "🏢",
                schedule: [.wednesday])
        ])
    ]
    
    private var tempCategory: TrackerCategory?
        
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - ITrackerCategoryRepository
    
    func fetchCategories() -> [TrackerCategory] {
        categories
    }
    
    func fetchSelectedCategoryName() -> String? {
        tempCategory?.header
    }
    
    func saveSelectedCategoryName(_ categoryName: String) {
        let newCategory = TrackerCategory(header: categoryName, trackers: [])
        addToExistedCategory(category: newCategory)
        tempCategory = newCategory
    }
 
    func createTracker(_ tracker: Tracker) throws {
        guard let tempCategory else {
            throw TrackerCategoryRepositoryError.requiredDataIsMissing
        }
        
        categories = categories.compactMap {
            if $0.header == tempCategory.header {
                var tempTrackers = $0.trackers
                tempTrackers.append(tracker)
                
                return .init(
                    header: tempCategory.header,
                    trackers: tempTrackers
                )
            }
            
            return .init(header: $0.header, trackers: $0.trackers)
        }
        
        flush()
    }
    
    private func addToExistedCategory(
        category: TrackerCategory
    ) {
        if isAlreadyHaveCategory(tracker: category) {
            categories = categories.compactMap {
                if $0.header == category.header {
                    var tempTrackers = $0.trackers
                    tempTrackers.append(contentsOf: category.trackers)
                    return .init(header: $0.header, trackers: tempTrackers)
                }
                return .init(header: $0.header, trackers: $0.trackers)
            }
        } else {
            categories.append(category)
        }
    }
    
    private func isAlreadyHaveCategory(tracker: TrackerCategory) -> Bool {
        categories.contains(where: { $0.header == tracker.header })
    }
    
    private func flush() {
        tempCategory = nil
    }
}
