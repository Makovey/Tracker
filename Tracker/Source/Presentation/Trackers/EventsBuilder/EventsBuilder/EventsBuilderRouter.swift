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
    
    weak var viewController: UINavigationController?

    // MARK: - Public
    
    func dismissModule() {
        viewController?.dismiss(animated: true)
    }
    
    func openCategoryScreen(
        categoryModuleOutput: some ICategorySelectorOutput,
        selectedCategory: String?
    ) {
        let destination = CategorySelectorAssembly.assemble(
            navigationController: viewController,
            output: categoryModuleOutput
        )
        (destination as? ICategorySelectorInput)?.setSelectedCategory(category: selectedCategory)
        viewController?.pushViewController(destination, animated: true)
    }
    
    func openScheduleScreen(
        scheduleModuleOutput: some IEventsScheduleOutput,
        selectedDays: Set<WeekDay>
    ) {
        let destination = EventsScheduleAssembly.assemble(
            navigationController: viewController,
            output: scheduleModuleOutput
        )
        (destination as? IEventsScheduleInput)?.setSelectedDays(selectedDays: selectedDays)
        viewController?.pushViewController(destination, animated: true)
    }
}