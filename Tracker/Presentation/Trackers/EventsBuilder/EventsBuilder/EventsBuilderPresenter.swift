//
//  EventsBuilderPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 25.01.2024.
//

import Foundation

protocol IEventsBuilderPresenter {
    func cancelButtonTapped()
    func createButtonTapped()
    func categoryTapped()
    func scheduleTapped()
}

final class EventsBuilderPresenter {
    // MARK: - Properties
    
    private let router: any IEventsBuilderRouter
    weak var view: (any IEventsBuilderView)?

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
    
    func createButtonTapped() {
        print(#function)
    }
    
    func scheduleTapped() {
        router.openScheduleScreen(scheduleModuleOutput: self)
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
        view?.updateScheduleField(with: schedule)
    }
}
