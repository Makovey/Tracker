//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import Foundation

protocol ITrackersPresenter {
    func viewDidLoad()
    func addTrackerButtonTapped()
    func isEditingAvailableForThisDay(date: Date) -> Bool
    func isTrackerCompletedForThisDay(
        date: Date,
        record: TrackerRecord,
        id: UUID
    ) -> Bool

    func saveCategoryRecord(_ record: TrackerRecord)
    func deleteCategoryRecord(id: UUID?)
}

final class TrackersPresenter: ITrackersPresenter {
    // MARK: - Properties

    weak var view: (any ITrackersView)?
    private let router: any ITrackersRouter
    private let trackerRepository: any ITrackerRepository
    private var todaysId: UUID?

    // MARK: - Lifecycle

    init(
        router: some ITrackersRouter,
        trackerRepository: some ITrackerRepository
    ) {
        self.router = router
        self.trackerRepository = trackerRepository
    }
    
    // MARK: - Public
    
    func viewDidLoad() {
        view?.updateTrackerRecordList(with: trackerRepository.fetchRecords())
        view?.updateTrackerList(with: trackerRepository.fetchCategories())
    }

    func addTrackerButtonTapped() {
        router.openEventsSelectorScreen(builderOutput: self)
    }
    
    func isEditingAvailableForThisDay(date: Date) -> Bool {
        Calendar.current.compare(date, to: Date(), toGranularity: .day) != .orderedDescending
    }
    
    func isTrackerCompletedForThisDay(
        date: Date,
        record: TrackerRecord,
        id: UUID
    ) -> Bool {
        guard record.trackerId == id else { return false }
        return Calendar.current.compare(date, to: record.endDate, toGranularity: .day) == .orderedSame
    }

    func saveCategoryRecord(_ record: TrackerRecord) {
        todaysId = record.id
        trackerRepository.save(record: record)
    }

    func deleteCategoryRecord(id: UUID?) {
        let safeId = id != nil ? id : todaysId
        guard let safeId else { return assertionFailure("Can't delete record, because id is nil") }
        trackerRepository.deleteRecordById(safeId)
    }
}

// MARK: - IEventsBuilderOutput

extension TrackersPresenter: IEventsBuilderOutput {
    func didCreateNewTracker() {
        view?.updateTrackerList(with: trackerRepository.fetchCategories())
    }
}
