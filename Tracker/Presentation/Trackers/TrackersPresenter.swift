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
}

final class TrackersPresenter: ITrackersPresenter {
    // MARK: - Properties

    weak var view: (any ITrackersView)?
    private let router: any ITrackersRouter
    private let trackerRepository: any ITrackerRepository

    // MARK: - Lifecycle

    init(
        router: some ITrackersRouter,
        categoryRepository: some ITrackerRepository
    ) {
        self.router = router
        self.trackerRepository = categoryRepository
    }
    
    // MARK: - Public
    
    func viewDidLoad() {
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

    // MARK: - Private
    
}

// MARK: - IEventsBuilderOutput

extension TrackersPresenter: IEventsBuilderOutput {
    func didCreateNewTracker() {
        view?.updateTrackerList(with: trackerRepository.fetchCategories())
    }
}
