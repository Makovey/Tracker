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
    let output: any IEventsBuilderOutput
    
    init(output: some IEventsBuilderOutput) {
        self.output = output
    }

    // MARK: - Public
    
    func openEventBuilderScreenWithHabit() {
        let destination = EventsBuilderAssembly.assemble(
            with: .habit,
            navigationController: viewController,
            output: output
        )
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    func openEventBuilderScreenWithIrregularEvent() {
        let destination = EventsBuilderAssembly.assemble(
            with: .event,
            navigationController: viewController,
            output: output
        )
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
}
