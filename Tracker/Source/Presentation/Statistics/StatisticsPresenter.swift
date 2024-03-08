//
//  StatisticsPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import Foundation

protocol IStatisticsPresenter {
    func viewDidLoad()
}

final class StatisticsPresenter {
    // Dependencies

    private let router: any IStatisticsRouter
    weak var view: (any IStatisticsView)?

    // MARK: - Lifecycle

    init(router: some IStatisticsRouter) {
        self.router = router
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - IHabitsPresenter

extension StatisticsPresenter: IStatisticsPresenter {
    func viewDidLoad() { }
}
