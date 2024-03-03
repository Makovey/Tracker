//
//  EventsSelectorAssembly.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 21.01.2024.
//

import UIKit

final class EventsSelectorAssembly {
    // MARK: - Public
    
    static func assemble(builderOutput: some IEventsBuilderOutput) -> UIViewController {
        let router = EventsSelectorRouter(output: builderOutput)
        let presenter = EventsSelectorPresenter(router: router)
        let view = EventsSelectorViewController(presenter: presenter)

        router.viewController = view
        presenter.view = view

        return view
    }
}
