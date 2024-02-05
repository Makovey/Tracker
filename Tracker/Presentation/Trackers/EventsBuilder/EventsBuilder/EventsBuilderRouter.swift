//
//  EventsSelectorRouter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 25.01.2024.
//

import UIKit

protocol IEventsBuilderRouter { 
    func dismissModule()
    func openCategoryScreen(categoryModuleOutput: some ICategorySelectorOutput)
    func openScheduleScreen(scheduleModuleOutput: some IEventsScheduleOutput)
}

final class EventsBuilderRouter: IEventsBuilderRouter {

    // MARK: - Properties
    
    weak var viewController: UINavigationController?

    // MARK: - Public
    
    func dismissModule() {
        viewController?.dismiss(animated: true)
    }
    
    func openScheduleScreen(scheduleModuleOutput: some IEventsScheduleOutput) {
        let destination = EventsScheduleAssembly.assemble(
            navigationController: viewController,
            output: scheduleModuleOutput
        )
        viewController?.pushViewController(destination, animated: true)
    }
    
    func openCategoryScreen(categoryModuleOutput: some ICategorySelectorOutput) {
        let destination = CategorySelectorAssembly.assemble(
            navigationController: viewController,
            output: categoryModuleOutput
        )
        viewController?.pushViewController(destination, animated: true)
    }
}
