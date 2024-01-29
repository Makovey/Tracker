//
//  EventsSelectorRouter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 25.01.2024.
//

import UIKit

protocol IEventsBuilderRouter { 
    func dismissModule()
    func openScheduleScreen()
}

final class EventsBuilderRouter: IEventsBuilderRouter {

    // MARK: - Properties
    
    weak var viewController: UIViewController?

    // MARK: - Public
    
    func dismissModule() {
        viewController?.dismiss(animated: true)
    }
    
    func openScheduleScreen() {
        guard let navigationController = viewController?.navigationController else {
            fatalError("NavigationController is missing")
        }

        let destination = EventsScheduleAssembly.assemble(navigationController: viewController)
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
}
