//
//  EventsSchedulePresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 29.01.2024.
//

import Foundation

protocol IEventsSchedulePresenter {
    func doneButtonTapped(selectedDays: Set<WeekDay>)
}

final class EventsSchedulePresenter: IEventsSchedulePresenter {
    // MARK: - Properties

    weak var view: (any IEventsScheduleView)?
    weak var output: (any IEventsScheduleOutput)?
    private let router: any IEventsScheduleRouter

    // MARK: - Initialization

    init(router: some IEventsScheduleRouter) {
        self.router = router
    }

    // MARK: - Public

    func doneButtonTapped(selectedDays: Set<WeekDay>) {
        output?.scheduleSelected(selectedDays)
        router.popScreen()
    }

    // MARK: - Private
}
