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
        router.openCategoryScreen()
    }
    
    func cancelButtonTapped() {
        router.dismissModule()
    }
    
    func createButtonTapped() {
        print(#function)
    }
    
    func scheduleTapped() {
        router.openScheduleScreen()
    }
}
