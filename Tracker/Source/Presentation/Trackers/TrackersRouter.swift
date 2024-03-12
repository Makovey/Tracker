//
//  TrackersRouter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

protocol ITrackersRouter { 
    func openEventsSelectorScreen(builderOutput: some IEventsBuilderOutput)
    func openFilterScreen(
        filterModuleOutput: some IFilterOutput,
        selectedFilter: FilterType
    )
    func openEditScreen(
        output: some IEventsBuilderOutput,
        trackerId: UUID,
        with event: EventType
    )
}

final class TrackersRouter: ITrackersRouter {
    // MARK: - Properties

    weak var viewController: UIViewController?

    // MARK: - Public
    
    func openEventsSelectorScreen(builderOutput: some IEventsBuilderOutput) {
        let destination = UINavigationController(rootViewController: EventsSelectorAssembly.assemble(builderOutput: builderOutput))
        viewController?.present(destination, animated: true)
    }

    func openFilterScreen(
        filterModuleOutput: some IFilterOutput,
        selectedFilter: FilterType
    ) {
        let filterController = FilterAssembly.assemble(output: filterModuleOutput)
        let destination = UINavigationController(rootViewController: filterController)
        (filterController as? IFilterInput)?.setSelectedFilter(filter: selectedFilter)
        viewController?.present(destination, animated: true)
    }

    func openEditScreen(
        output: some IEventsBuilderOutput,
        trackerId: UUID,
        with event: EventType
    ) {
        let builderModule = EventsBuilderAssembly.assemble(
            with: event,
            output: output,
            trackerId: trackerId
        )

        let destination = UINavigationController(rootViewController: builderModule)
        viewController?.present(destination, animated: true)
    }

    // MARK: - Private
}
