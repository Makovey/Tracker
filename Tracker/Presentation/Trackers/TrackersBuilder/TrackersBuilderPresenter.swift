//
//  TrackersBuilderViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 21.01.2024.
//

import Foundation

protocol ITrackersBuilderPresenter {
    func viewDidLoad()
}

final class TrackersBuilderPresenter {
    // MARK: - Properties
    
    private let router: ITrackersBuilderRouter
    weak var view: ITrackersBuilderView?

    // MARK: - Lifecycle

    init(router: ITrackersBuilderRouter) {
        self.router = router
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - ITrackersBuilderPresenter

extension TrackersBuilderPresenter: ITrackersBuilderPresenter {
    func viewDidLoad() { }
}
