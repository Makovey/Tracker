//
//  TrackersRouter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

protocol ITrackersRouter { 
    func openTrackersBuilderScreen()
}

final class TrackersRouter: ITrackersRouter {
    // Dependencies

    weak var viewController: UIViewController?

    // MARK: - Public
    
    func openTrackersBuilderScreen() {
        let destination = TrackersBuilderAssembly.assemble()
        viewController?.present(destination, animated: true)
    }

    // MARK: - Private
}
