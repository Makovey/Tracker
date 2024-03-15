//
//  StatisticsPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import Foundation

protocol IStatisticsPresenter {
    func viewWillAppear()
}

final class StatisticsPresenter {
    // MARK: - Properties

    private let router: any IStatisticsRouter
    private let trackerRepository: any ITrackerRepository
    weak var view: (any IStatisticsView)?

    // MARK: - Lifecycle

    init(
        router: some IStatisticsRouter,
        trackerRepository: some ITrackerRepository
    ) {
        self.router = router
        self.trackerRepository = trackerRepository
    }

    // MARK: - Public

    // MARK: - Private

    private func recordsCount() -> Int {
        trackerRepository.fetchRecords().count
    }
}

// MARK: - IStatisticsPresenter

extension StatisticsPresenter: IStatisticsPresenter {
    func viewWillAppear() {
        var models = [StatisticsCell.Model]()
        let records = recordsCount()

        if records != .zero {
            models = [
                // TODO: change counter for best period
                .init(counter: records, description: .loc.Statistics.BestPeriod.title),
                // TODO: change counter for ideal days
                .init(counter: records, description: .loc.Statistics.IdealDays.title),
                .init(counter: records, description: .loc.Statistics.TrackersCompleted.title),
                // TODO: change counter for average title
                .init(counter: records, description: .loc.Statistics.AverageValue.title),
            ]
        }

        view?.updateStatistics(with: models)
    }
}
