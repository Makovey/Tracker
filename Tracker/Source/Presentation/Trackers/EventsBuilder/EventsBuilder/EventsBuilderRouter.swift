//
//  EventsSelectorRouter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 25.01.2024.
//

import UIKit

protocol IEventsBuilderRouter { 
    func dismissModule()
    func openCategoryScreen(
        categoryModuleOutput: some ICategorySelectorOutput,
        selectedCategory: String?
    )
    func openScheduleScreen(
        scheduleModuleOutput: some IEventsScheduleOutput,
        selectedDays: Set<WeekDay>
    )
}

final class EventsBuilderRouter: IEventsBuilderRouter {

    // MARK: - Properties
    
    weak var viewController: UIViewController?

    // MARK: - Public
    
    func dismissModule() {
        viewController?.dismiss(animated: true)
    }
    
    func openCategoryScreen(
        categoryModuleOutput: some ICategorySelectorOutput,
        selectedCategory: String?
    ) {
        guard let navigationController = viewController?.navigationController else {
            assertionFailure("NavigationController is nil")
            return
        }

        let destination = CategorySelectorAssembly.assemble(
            navigationController: navigationController,
            output: categoryModuleOutput
        )
        (destination as? ICategorySelectorInput)?.setSelectedCategory(category: selectedCategory)
        navigationController.pushViewController(destination, animated: true)
    }
    
    func openScheduleScreen(
        scheduleModuleOutput: some IEventsScheduleOutput,
        selectedDays: Set<WeekDay>
    ) {
        guard let navigationController = viewController?.navigationController else {
            assertionFailure("NavigationController is nil")
            return
        }

        let destination = EventsScheduleAssembly.assemble(
            navigationController: navigationController,
            output: scheduleModuleOutput
        )
        (destination as? IEventsScheduleInput)?.setSelectedDays(selectedDays: selectedDays)
        navigationController.pushViewController(destination, animated: true)
    }
}
