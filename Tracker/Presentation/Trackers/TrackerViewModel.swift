//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 25.02.2024.
//

import Foundation

protocol ITrackerViewModel {
    var fullCategoryListBinding: Binding<[TrackerCategory]>? { get set }
    var visibilityCategoryListBinding: Binding<[TrackerCategory]>? { get set }
    var completedTrackersBinding: Binding<[TrackerRecord]>? { get set }

    func saveCategoryRecord(_ record: TrackerRecord)
    func deleteCategoryRecord(id: UUID)
}

final class TrackerViewModel: ITrackerViewModel {
    var fullCategoryListBinding: Binding<[TrackerCategory]>?
    var visibilityCategoryListBinding: Binding<[TrackerCategory]>?
    var completedTrackersBinding: Binding<[TrackerRecord]>? {
        didSet { completedTrackers = trackerRepository.fetchRecords() }
    }

    var completedTrackers = [TrackerRecord]() {
        didSet { completedTrackersBinding?(completedTrackers) }
    }

    private let trackerRepository: any ITrackerRepository

    private var fullCategoryList = [TrackerCategory]() {
        didSet { fullCategoryListBinding?(fullCategoryList) }
    }

    private var visibilityCategoryList = [TrackerCategory]() {
        didSet { visibilityCategoryListBinding?(visibilityCategoryList) }
    }

    init(trackerRepository: some ITrackerRepository) {
        self.trackerRepository = trackerRepository
    }

    func saveCategoryRecord(_ record: TrackerRecord) {
        trackerRepository.save(record: record)
        completedTrackers.append(record)
    }

    func deleteCategoryRecord(id: UUID) {
        trackerRepository.deleteRecordById(id)
        completedTrackers = completedTrackers.filter { $0.id != id }
    }
}
