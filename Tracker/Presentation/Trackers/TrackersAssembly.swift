//
//  TrackersAssembly.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

final class TrackersAssembly {
    // MARK: - Public

    static func assemble() -> UIViewController {
        let router = TrackersRouter()
        let presenter = TrackersPresenter(router: router)
        let view = TrackersViewController(presenter: presenter)

        router.viewController = view
        presenter.view = view

        return view
    }
}
