//
//  TrackersAssembly.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

final class TrackersAssembly {
    // MARK: - Public

    static func assemble() -> UIViewController {
        let storage: IPersistenceStorage = CoreDataStorage()
        let repository: ITrackerRepository = TrackerRepository(storage: storage)
        
        let router = TrackersRouter()
        let presenter = TrackersPresenter(
            router: router,
            categoryRepository: repository
        )
        
        let layoutProvider = TrackersLayoutProvider()
        let view = TrackersViewController(
            presenter: presenter,
            layoutProvider: layoutProvider
        )

        router.viewController = view
        presenter.view = view

        return view
    }
}
