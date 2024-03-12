//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import Foundation

protocol ITrackersPresenter {
    func viewDidLoad()
    func viewDidAppear()
    func viewDidDisappear()
    func addTrackerButtonTapped()
    func isEditingAvailableForThisDay(date: Date) -> Bool
    func isTrackerCompletedForThisDay(
        date: Date,
        record: TrackerRecord,
        id: UUID
    ) -> Bool

    func doneButtonTapped(with record: TrackerRecord)
    func deleteCategoryRecord(id: UUID?) -> UUID?
    func filterButtonTapped()
    func setAllFilter()

    func pinActionTapped(tracker: Tracker)
    func editActionTapped()
    func deleteActionTapped(trackerId: UUID)
}

final class TrackersPresenter: ITrackersPresenter {
    // MARK: - Properties

    weak var view: (any ITrackersView)?
    private let router: any ITrackersRouter
    private let trackerRepository: any ITrackerRepository
    private let analyticsManager: any IAnalyticsManager
    private var todaysId: UUID?
    private var filterTypeSelected: FilterType = .all

    // MARK: - Lifecycle

    init(
        router: some ITrackersRouter,
        trackerRepository: some ITrackerRepository,
        analyticsManager: some IAnalyticsManager
    ) {
        self.router = router
        self.trackerRepository = trackerRepository
        self.analyticsManager = analyticsManager
    }
    
    // MARK: - Public
    
    func viewDidLoad() {
        view?.updateTrackerRecordList(with: trackerRepository.fetchRecords())
        assembleTrackerList()
        view?.setFilterType(filterType: filterTypeSelected)
    }

    func viewDidAppear() {
        analyticsManager.sendEvent(.open)
    }

    func viewDidDisappear() {
        analyticsManager.sendEvent(.close)
    }

    func addTrackerButtonTapped() {
        analyticsManager.sendTapEvent(.addTrack)
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

    func doneButtonTapped(with record: TrackerRecord) {
        analyticsManager.sendTapEvent(.track)

        todaysId = record.id
        trackerRepository.save(record: record)
    }

    func deleteCategoryRecord(id: UUID?) -> UUID? {
        let safeId = id != nil ? id : todaysId
        guard let safeId else { assertionFailure("Can't delete record, because id is nil"); return nil }
        trackerRepository.deleteRecordById(safeId)
        return safeId
    }

    func filterButtonTapped() {
        analyticsManager.sendTapEvent(.filter)

        router.openFilterScreen(
            filterModuleOutput: self,
            selectedFilter: filterTypeSelected
        )
    }

    func setAllFilter() {
        filterTypeSelected = .all
    }

    func pinActionTapped(tracker: Tracker) {
        let newTracker = Tracker(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            schedule: tracker.schedule,
            isPinned: !tracker.isPinned
        )

        trackerRepository.replaceTracker(newTracker)
        assembleTrackerList()
    }

    func editActionTapped() {
        analyticsManager.sendTapEvent(.edit)
        
        print(#function)
    }

    func deleteActionTapped(trackerId: UUID) {
        analyticsManager.sendTapEvent(.delete)

        trackerRepository.deleteTrackerById(trackerId)
        assembleTrackerList()
    }

    private func assembleTrackerList() {
        let allCategories = trackerRepository.fetchAllCategories()
        let allPinnedTrackers = allCategories.flatMap { $0.trackers.filter { $0.isPinned } }

        let category = TrackerCategory(header: "Pin", trackers: allPinnedTrackers) // TODO
        let categoryWithoutPinnedTrackers = allCategories
            .map { TrackerCategory(
                header: $0.header,
                trackers: $0.trackers.filter { !$0.isPinned })
            }

        let final = [category] + categoryWithoutPinnedTrackers

        view?.updateTrackerList(with: final)
    }
}

// MARK: - IEventsBuilderOutput

extension TrackersPresenter: IEventsBuilderOutput {
    func didCreateNewTracker() {
        assembleTrackerList()
    }
}

// MARK: - IFilterOutput

extension TrackersPresenter: IFilterOutput {
    func filterSelected(_ filter: FilterType) {
        filterTypeSelected = filter

        switch filter {
        case .all:
            assembleTrackerList()
            view?.setFilterType(filterType: filterTypeSelected)
        case .today:
            view?.setFilterType(filterType: filterTypeSelected)
            view?.setCurrentDate()
            assembleTrackerList()
        case .completed:
            let ids = trackerRepository.fetchRecords().map { $0.trackerId }

            let completedTrackers = trackerRepository
                .fetchAllCategories()
                .map { TrackerCategory(
                    header: $0.header,
                    trackers: $0.trackers.filter { ids.contains($0.id) })
                }

            view?.setFilterType(filterType: filterTypeSelected)
            view?.updateTrackerList(with: completedTrackers)

        case .inProgress:
            let ids = trackerRepository.fetchRecords().map { $0.trackerId }

            let inProgressTrackers = trackerRepository
                .fetchAllCategories()
                .map { TrackerCategory(
                    header: $0.header,
                    trackers: $0.trackers.filter { !ids.contains($0.id) })
                }

            view?.setFilterType(filterType: filterTypeSelected)
            view?.updateTrackerList(with: inProgressTrackers)
        }
    }
}
