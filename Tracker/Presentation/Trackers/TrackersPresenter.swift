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

    private let router: ITrackersRouter
    weak var view: ITrackersView?

    // MARK: - Lifecycle

    init(router: ITrackersRouter) {
        self.router = router
    }
    
    // MARK: - Public

    // MARK: - Private
}

// MARK: - ITrackerPresenter

extension TrackersPresenter: ITrackersPresenter {
    func addTrackerButtonTapped() {
        router.openTrackersBuilderScreen()
    }
}
