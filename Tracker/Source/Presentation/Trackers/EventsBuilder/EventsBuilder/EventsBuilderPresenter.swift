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
}

final class EventsBuilderPresenter {
    // MARK: - Properties
    
    weak var view: (any IEventsBuilderView)?
    weak var output: (any IEventsBuilderOutput)?
    
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
        case .habit:
            trackerToFill.trackerName?.isEmpty == false &&
            trackerToFill.categoryName?.isEmpty == false &&
            trackerToFill.schedule?.isEmpty == false &&
            trackerToFill.selectedEmoji?.isEmpty == false &&
            trackerToFill.selectedColor != nil
        case .event:
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
