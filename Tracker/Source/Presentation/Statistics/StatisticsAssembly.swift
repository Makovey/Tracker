//
//  StatisticsAssembly.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

final class StatisticsAssembly {
    // MARK: - Public
    
    static func assemble() -> UIViewController {
        let storage: IPersistenceStorage = CoreDataStorage()
        let repository: ITrackerRepository = TrackerRepository(storage: storage)

        let router = StatisticsRouter()
        let presenter = StatisticsPresenter(
            router: router,
            trackerRepository: repository
        )
        let view = StatisticsViewController(presenter: presenter)

        router.viewController = view
        presenter.view = view

        return view
    }
}
