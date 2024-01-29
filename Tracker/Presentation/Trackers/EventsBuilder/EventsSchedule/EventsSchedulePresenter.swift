//
//  EventsSchedulePresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 29.01.2024.
//

import Foundation

protocol IEventsSchedulePresenter { }

final class EventsSchedulePresenter {
    // MARK: = Properties

    private let router: IEventsScheduleRouter
    weak var view: IEventsScheduleView?

    // MARK: - Initialization

    init(router: IEventsScheduleRouter) {
        self.router = router
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - IEventsSchedulePresenter

extension EventsSchedulePresenter: IEventsSchedulePresenter {
}
