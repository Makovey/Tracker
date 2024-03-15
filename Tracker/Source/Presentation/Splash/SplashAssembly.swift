//
//  SplashAssembly.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 25.02.2024
//

import UIKit

final class SplashAssembly {
    // MARK: - Public

    static func assemble() -> UIViewController {
        let router = SplashRouter()
        let presenter = SplashPresenter(
            router: router,
            authStorage: AuthStorage()
        )
        let view = SplashViewController(presenter: presenter)

        presenter.view = view

        return view
    }
}
