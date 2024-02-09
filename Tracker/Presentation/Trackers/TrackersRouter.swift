//
//  TrackersRouter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

protocol ITrackersRouter { 
    func openEventsSelectorScreen(builderOutput: some IEventsBuilderOutput)
}

final class TrackersRouter: ITrackersRouter {
    // MARK: - Properties

    weak var viewController: UIViewController?

    // MARK: - Public
    
    func openEventsSelectorScreen(builderOutput: some IEventsBuilderOutput) {
        let destination = UINavigationController(rootViewController: EventsSelectorAssembly.assemble(builderOutput: builderOutput))
        viewController?.present(destination, animated: true)
    }

    // MARK: - Private
}
