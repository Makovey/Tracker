//
//  EventsBuilderPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 25.01.2024.
//

import Foundation

protocol IEventsBuilderOutput: AnyObject {
    func setNewTracker(tracker: TrackerCategory)
}

protocol IEventsBuilderPresenter {
    func cancelButtonTapped()
    func createButtonTapped(with tracker: TrackerCategory)
    func categoryTapped()
    func scheduleTapped()
}

final class EventsBuilderPresenter {
    // MARK: - Properties
    
    private let router: any IEventsBuilderRouter
    weak var view: (any IEventsBuilderView)?
    weak var output: (any IEventsBuilderOutput)?
    private var selectedDays = Set<WeekDay>()

    // MARK: - Lifecycle

    init(router: some IEventsBuilderRouter) {
        self.router = router
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - IEventsBuilderPresenter

extension EventsBuilderPresenter: IEventsBuilderPresenter {
    func categoryTapped() {
        router.openCategoryScreen(categoryModuleOutput: self)
    }
    
    func cancelButtonTapped() {
        router.dismissModule()
    }
    
    func createButtonTapped(with tracker: TrackerCategory) {
        output?.setNewTracker(tracker: tracker)
        router.dismissModule()
    }
    
    func scheduleTapped() {
        router.openScheduleScreen(
            scheduleModuleOutput: self,
            selectedDays: selectedDays
        )
    }
}

// MARK: - ICategorySelectorOutput

extension EventsBuilderPresenter: ICategorySelectorOutput {
    func categorySelected(_ category: String) {
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
