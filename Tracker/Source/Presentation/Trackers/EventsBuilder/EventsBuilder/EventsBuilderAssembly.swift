//
//  EventsBuilderAssembly.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 25.01.2024.
//

import UIKit

final class EventsBuilderAssembly {
    // MARK: - Public
    
    static func assemble(
        with mode: EventType,
        navigationController: UIViewController?,
        output: some IEventsBuilderOutput
    ) -> UIViewController {
        let storage: IPersistenceStorage = CoreDataStorage()
        let repository: ITrackerRepository = TrackerRepository(storage: storage)
        
        let router = EventsBuilderRouter()
        let presenter = EventsBuilderPresenter(
            router: router,
            categoryRepository: repository
        )
        let view = EventsBuilderViewController(
            mode: mode,
            presenter: presenter,
            layoutProvider: EventsBuilderLayoutProvider()
        )

        router.viewController = navigationController
        presenter.view = view
        presenter.output = output

        return view
    }

    static func assemble(
        with mode: EventType,
        output: some IEventsBuilderOutput,
        trackerId: UUID?
    ) -> UIViewController {
        let storage: IPersistenceStorage = CoreDataStorage()
        let repository: ITrackerRepository = TrackerRepository(storage: storage)

        let router = EventsBuilderRouter()
        let presenter = EventsBuilderPresenter(
            router: router,
            categoryRepository: repository
        )
        let view = EventsBuilderViewController(
            mode: mode,
            presenter: presenter,
            layoutProvider: EventsBuilderLayoutProvider()
        )

        router.viewController = view
        presenter.view = view
        presenter.output = output
        presenter.editingTrackerId = trackerId

        return view
    }
}
