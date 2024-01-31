//
//  EventsSelectorRouter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 21.01.2024.
//

import UIKit

protocol IEventsSelectorRouter { 
    func openEventBuilderScreenWithHabit()
    func openEventBuilderScreenWithIrregularEvent()
}

final class EventsSelectorRouter: IEventsSelectorRouter {
    // MARK: - Properties
    
    weak var viewController: UIViewController?

    // MARK: - Public
    
    func openEventBuilderScreenWithHabit() {
        guard let navigationController = viewController?.navigationController else {
            fatalError("NavigationController is missing")
        }

        let destination = EventsBuilderAssembly.assemble(with: .habit, navigationController: navigationController)
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func openEventBuilderScreenWithIrregularEvent() {
        guard let navigationController = viewController?.navigationController else {
            fatalError("NavigationController is missing")
        }

        let destination = EventsBuilderAssembly.assemble(with: .event, navigationController: navigationController)
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
}
