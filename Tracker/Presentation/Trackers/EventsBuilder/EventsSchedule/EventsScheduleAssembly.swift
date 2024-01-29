//
//  EventsScheduleAssembly.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 29.01.2024.
//

import UIKit

final class EventsScheduleAssembly {
    // MARK: - Public
    
    static func assemble(navigationController: UIViewController?) -> UIViewController {
        let router = EventsScheduleRouter()
        let presenter = EventsSchedulePresenter(router: router)
        let view = EventsScheduleViewController(presenter: presenter)

        router.viewController = navigationController
        presenter.view = view

        return view
    }
}
