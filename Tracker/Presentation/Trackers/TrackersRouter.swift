//
//  TrackersRouter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

protocol ITrackersRouter { 
    func openEventsSelectorScreen()
}

final class TrackersRouter: ITrackersRouter {
    // Dependencies

    weak var viewController: UIViewController?

    // MARK: - Public
    
    func openEventsSelectorScreen() {
        let destination = UINavigationController(rootViewController: EventsSelectorAssembly.assemble())
        viewController?.present(destination, animated: true)
    }

    // MARK: - Private
}
