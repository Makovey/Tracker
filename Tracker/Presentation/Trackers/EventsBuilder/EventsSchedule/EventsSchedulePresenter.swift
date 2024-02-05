//
//  EventsSchedulePresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 29.01.2024.
//

import Foundation

protocol IEventsScheduleOutput: AnyObject {
    func scheduleSelected(_ schedule: Set<WeekDay>)
}

protocol IEventsSchedulePresenter {
    func doneButtonTapped(selectedDays: Set<WeekDay>)
}

final class EventsSchedulePresenter {
    // MARK: - Properties

    private let router: any IEventsScheduleRouter
    weak var view: (any IEventsScheduleView)?
    weak var output: (any IEventsScheduleOutput)?

    // MARK: - Initialization

    init(router: some IEventsScheduleRouter) {
        self.router = router
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - IEventsSchedulePresenter

extension EventsSchedulePresenter: IEventsSchedulePresenter {
    func doneButtonTapped(selectedDays: Set<WeekDay>) {
        output?.scheduleSelected(selectedDays)
        router.popScreen()
    }
}
