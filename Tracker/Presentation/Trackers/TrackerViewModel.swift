//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 25.02.2024.
//

import Foundation

protocol ITrackerViewModel {
    var fullCategoryListBinding: Binding<[TrackerCategory]>? { get set }
    var completedTrackersBinding: Binding<[TrackerRecord]>? { get set }

    func updateCategories()
    func saveCategoryRecord(_ record: TrackerRecord)
    func deleteCategoryRecord(id: UUID?)
}

final class TrackerViewModel: ITrackerViewModel {
    // MARK: - Bindings

    var fullCategoryListBinding: Binding<[TrackerCategory]>? {
        didSet { fullCategoryListBinding?(trackerRepository.fetchCategories()) }
    }

    var completedTrackersBinding: Binding<[TrackerRecord]>? {
        didSet { completedTrackers = trackerRepository.fetchRecords() }
    }

    // MARK: Private

    private var completedTrackers = [TrackerRecord]() {
        didSet { completedTrackersBinding?(completedTrackers) }
    }

    // MARK: - Properties

    private let trackerRepository: any ITrackerRepository
    private var todaysId: UUID?

    // MARK: - Lifecycle

    init(trackerRepository: some ITrackerRepository) {
        self.trackerRepository = trackerRepository
    }

    // MARK: - Public

    func saveCategoryRecord(_ record: TrackerRecord) {
        trackerRepository.save(record: record)
        completedTrackers.append(record)
        todaysId = record.id
    }

    func deleteCategoryRecord(id: UUID?) {
        let safeId = id != nil ? id : todaysId
        guard let safeId else { return assertionFailure("Can't delete record, because id is nil") }
        trackerRepository.deleteRecordById(safeId)
        completedTrackers = completedTrackers.filter { $0.id != safeId }
    }

    func updateCategories() {
        fullCategoryListBinding?(trackerRepository.fetchCategories())
    }
}
