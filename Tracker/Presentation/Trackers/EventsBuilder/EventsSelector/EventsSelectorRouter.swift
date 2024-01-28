//
//  EventsSelectorRouter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 21.01.2024.
//

import UIKit

protocol IEventsSelectorRouter { 
    func habitButtonTapped()
    func irregularEventsButtonTapped()
}

final class EventsSelectorRouter: IEventsSelectorRouter {
    // MARK: - Properties
    
    weak var viewController: UIViewController?

    // MARK: - Public
    
    func habitButtonTapped() {
        guard let navigationController = viewController?.navigationController else {
            fatalError("NavigationController is missing")
        }

        let destination = EventsBuilderAssembly.assemble(with: .habit, navigationController: navigationController)
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func irregularEventsButtonTapped() {
        guard let navigationController = viewController?.navigationController else {
            fatalError("NavigationController is missing")
        }

        let destination = EventsBuilderAssembly.assemble(with: .event, navigationController: navigationController)
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
}
