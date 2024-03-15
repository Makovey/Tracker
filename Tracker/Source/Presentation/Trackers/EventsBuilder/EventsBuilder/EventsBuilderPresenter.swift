//
//  EventsBuilderPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 25.01.2024.
//

import Foundation

protocol IEventsBuilderPresenter {
    func cancelButtonTapped()
    func createButtonTapped(with tracker: Tracker)
    func categoryTapped()
    func scheduleTapped()
    func canCreateFilledTracker(
        mode: EventType,
        trackerToFill: EventsBuilderViewController.TrackerToFill
    ) -> Bool
    func saveTracker(tracker: Tracker)
}

final class EventsBuilderPresenter {
    // MARK: - Properties
    
    weak var view: (any IEventsBuilderView)?
    weak var output: (any IEventsBuilderOutput)?
    var oldEditingCategory: String?
    var editingTrackerId: UUID? {
        didSet { setEditingCategory() }
    }

    private let router: any IEventsBuilderRouter
    private let categoryRepository: any ITrackerRepository
    private var selectedDays = Set<WeekDay>()

    // MARK: - Lifecycle

    init(
        router: some IEventsBuilderRouter,
        categoryRepository: some ITrackerRepository
    ) {
        self.router = router
        self.categoryRepository = categoryRepository
    }

    // MARK: - Public

    // MARK: - Private

    private func setEditingCategory() {
        guard let category = categoryRepository
            .fetchAllCategories()
            .filter({ $0.trackers.map { $0.id }.contains(editingTrackerId) }).first,
              let tracker = category.trackers.filter({ $0.id == editingTrackerId }).first
        else { return }

        oldEditingCategory = category.header
        categoryRepository.saveSelectedCategoryName(category.header)
        if let schedule = tracker.schedule {
            selectedDays = schedule
        }

        let completedTimes = categoryRepository.fetchRecords().filter { $0.trackerId == tracker.id }.count
        view?.setEditingTracker(
            trackerCategory: .init(
                header: category.header,
                trackers: [tracker]), 
            completedText: String.completedDays(completedTimes)
        )
    }
}

// MARK: - IEventsBuilderPresenter

extension EventsBuilderPresenter: IEventsBuilderPresenter {
    func categoryTapped() {
        router.openCategoryScreen(
            categoryModuleOutput: self,
            selectedCategory: categoryRepository.fetchSelectedCategoryName()
        )
    }
    
    func cancelButtonTapped() {
        router.dismissModule()
    }
    
    func createButtonTapped(with tracker: Tracker) {
        try? categoryRepository.createTracker(tracker) // TODO: handle exception
        output?.didCreateNewTracker()
        router.dismissModule()
    }

    func saveTracker(tracker: Tracker) {
        let isNewCategory = oldEditingCategory != categoryRepository.fetchSelectedCategoryName()
        categoryRepository.replaceTracker(tracker, isNewCategory: isNewCategory)


        output?.didCreateNewTracker()
        router.dismissModule()
    }

    func scheduleTapped() {
        router.openScheduleScreen(
            scheduleModuleOutput: self,
            selectedDays: selectedDays
        )
    }

    func canCreateFilledTracker(
        mode: EventType,
        trackerToFill: EventsBuilderViewController.TrackerToFill
    ) -> Bool {
        switch mode {
        case .habit, .editHabit:
            trackerToFill.trackerName?.isEmpty == false &&
            trackerToFill.categoryName?.isEmpty == false &&
            trackerToFill.schedule?.isEmpty == false &&
            trackerToFill.selectedEmoji?.isEmpty == false &&
            trackerToFill.selectedColor != nil
        case .event, .editEvent:
            trackerToFill.trackerName?.isEmpty == false &&
            trackerToFill.categoryName?.isEmpty == false &&
            trackerToFill.selectedEmoji?.isEmpty == false &&
            trackerToFill.selectedColor != nil
        }
    }
}

// MARK: - ICategorySelectorOutput

extension EventsBuilderPresenter: ICategorySelectorOutput {
    func categorySelected(_ category: String) {
        categoryRepository.saveSelectedCategoryName(category)
        view?.updateCategoryField(with: category)
    }
}

// MARK: - IEventsScheduleOutput

extension EventsBuilderPresenter: IEventsScheduleOutput {
    func scheduleSelected(_ schedule: Set<WeekDay>) {
        selectedDays = schedule
        view?.updateScheduleField(with: schedule)
    }
}
