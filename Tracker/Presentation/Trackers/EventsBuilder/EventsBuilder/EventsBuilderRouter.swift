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
    
    weak var viewController: UINavigationController?

    // MARK: - Public
    
    func dismissModule() {
        viewController?.dismiss(animated: true)
    }
    
    func openScheduleScreen() {
        let destination = EventsScheduleAssembly.assemble(navigationController: viewController)
        viewController?.pushViewController(destination, animated: true)
    }
}
