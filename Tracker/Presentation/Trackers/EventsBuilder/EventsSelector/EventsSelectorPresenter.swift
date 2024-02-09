//
//  EventsSelectorPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 21.01.2024.
//

import Foundation

protocol IEventsSelectorPresenter {
    func habitButtonTapped()
    func irregularEventsButtonTapped()
}

final class EventsSelectorPresenter {
    // MARK: - Properties
    
    private let router: any IEventsSelectorRouter
    weak var view: (any IEventsSelectorView)?

    // MARK: - Lifecycle

    init(router: some IEventsSelectorRouter) {
        self.router = router
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - IEventsSelectorPresenter

extension EventsSelectorPresenter: IEventsSelectorPresenter {
    func habitButtonTapped() {
        router.openEventBuilderScreenWithHabit()
    }
    
    func irregularEventsButtonTapped() {
        router.openEventBuilderScreenWithIrregularEvent()
    }
}
