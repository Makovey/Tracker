//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import Foundation

protocol ITrackersPresenter {
    func addTrackerButtonTapped()
}

final class TrackersPresenter {
    // Dependencies

    private let router: any ITrackersRouter
    weak var view: (any ITrackersView)?

    // MARK: - Lifecycle

    init(router: some ITrackersRouter) {
        self.router = router
    }
    
    // MARK: - Public

    // MARK: - Private
}

// MARK: - ITrackerPresenter

extension TrackersPresenter: ITrackersPresenter {
    func addTrackerButtonTapped() {
        router.openEventsSelectorScreen()
    }
}
