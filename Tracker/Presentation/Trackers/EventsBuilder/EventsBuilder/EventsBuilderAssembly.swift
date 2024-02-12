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
        navigationController: UINavigationController?,
        output: some IEventsBuilderOutput
    ) -> UIViewController {
        let router = EventsBuilderRouter()
        let presenter = EventsBuilderPresenter(
            storage: CoreDataStorage(), 
            router: router,
            categoryRepository: TrackerCategoryRepository.shared
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
}
