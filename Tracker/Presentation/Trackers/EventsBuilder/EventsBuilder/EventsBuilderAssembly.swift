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
        navigationController: UINavigationController?
    ) -> UIViewController {
        let router = EventsBuilderRouter()
        let presenter = EventsBuilderPresenter(router: router)
        let view = EventsBuilderViewController(presenter: presenter, mode: mode)

        router.viewController = navigationController
        presenter.view = view

        return view
    }
}
