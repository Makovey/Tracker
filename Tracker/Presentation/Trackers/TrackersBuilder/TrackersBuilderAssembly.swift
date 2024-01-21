//
//  TrackersBuilderAssembly.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 21.01.2024
//

import UIKit

final class TrackersBuilderAssembly {
    // MARK: - Public
    
    static func assemble() -> UIViewController {
        let router = TrackersBuilderRouter()
        let presenter = TrackersBuilderPresenter(router: router)
        let view = TrackersBuilderViewController(presenter: presenter)

        router.viewController = view
        presenter.view = view

        return view
    }
}
