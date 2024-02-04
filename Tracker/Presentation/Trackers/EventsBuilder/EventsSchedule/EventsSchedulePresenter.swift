//
//  EventsSchedulePresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 29.01.2024.
//

import Foundation

protocol IEventsSchedulePresenter {
    func doneButtonTapped()
}

final class EventsSchedulePresenter {
    // MARK: - Properties

    private let router: any IEventsScheduleRouter
    weak var view: (any IEventsScheduleView)?

    // MARK: - Initialization

    init(router: some IEventsScheduleRouter) {
        self.router = router
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - IEventsSchedulePresenter

extension EventsSchedulePresenter: IEventsSchedulePresenter {
    func doneButtonTapped() {
        router.popScreen()
    }
}
