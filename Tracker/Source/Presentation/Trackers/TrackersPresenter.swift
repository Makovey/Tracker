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

    func setChosenDate(date: Date)
    func doneButtonTapped(with record: TrackerRecord)
    func deleteCategoryRecord(id: UUID?) -> UUID?
    func filterButtonTapped()
    func updateIfNeeded(with filterType: FilterType)

    func pinActionTapped(tracker: Tracker)
    func editActionTapped(tracker: Tracker)
    func intentDeleteTracker(with id: UUID)
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
    private var chosenDate = Date()

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
    
    func setChosenDate(date: Date) {
        chosenDate = date
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

    func updateIfNeeded(with filterType: FilterType) {
        switch filterType {
        case .all, .today:
            filterTypeSelected = filterType
        case .inProgress, .completed:
            selectAndUpdate(filterType)
        }
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

        trackerRepository.replaceTracker(newTracker, isNewCategory: false)
        assembleTrackerList()
    }

    func editActionTapped(tracker: Tracker) {
        analyticsManager.sendTapEvent(.edit)
        
        let eventType: EventType = tracker.schedule == nil ? .editEvent : .editHabit
        router.openEditScreen(output: self, trackerId: tracker.id, with: eventType)
    }

    func deleteActionTapped(trackerId: UUID) {
        analyticsManager.sendTapEvent(.delete)

        trackerRepository.deleteTrackerById(trackerId)
        assembleTrackerList()
    }

    func intentDeleteTracker(with id: UUID) {
        view?.showAlert(trackerId: id)
    }

    private func assembleTrackerList() {
        let allCategories = trackerRepository.fetchAllCategories()
        view?.updateTrackerList(with: addedPinCategory(to: allCategories))
    }

    private func addedPinCategory(to categories: [TrackerCategory]) -> [TrackerCategory] {
        let allPinnedTrackers = categories.flatMap { $0.trackers.filter { $0.isPinned } }

        let pinCategory = TrackerCategory(header: .loc.Trackers.Category.pin, trackers: allPinnedTrackers)
        let categoryWithoutPinnedTrackers = categories
            .map { TrackerCategory(
                header: $0.header,
                trackers: $0.trackers.filter { !$0.isPinned })
            }

        return [pinCategory] + categoryWithoutPinnedTrackers
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
    func selectAndUpdate(_ filter: FilterType) {
        filterTypeSelected = filter

        switch filter {
        case .all:
            view?.setFilterType(filterType: filterTypeSelected)
            assembleTrackerList()
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
            view?.updateTrackerList(with: addedPinCategory(to: completedTrackers))

        case .inProgress:
            let ids = trackerRepository.fetchRecords().map { $0.trackerId }

            let inProgressTrackers = trackerRepository
                .fetchAllCategories()
                .map { TrackerCategory(
                    header: $0.header,
                    trackers: $0.trackers.filter { !ids.contains($0.id) })
                }

            view?.setFilterType(filterType: filterTypeSelected)
            view?.updateTrackerList(with: addedPinCategory(to: inProgressTrackers))
        }
    }
}
