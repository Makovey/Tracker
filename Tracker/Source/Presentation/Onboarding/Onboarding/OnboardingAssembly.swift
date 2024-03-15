//
//  OnboardingAssembly.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 25.02.2024
//

import UIKit

final class OnboardingAssembly {
    // MARK: - Public

    static func assemble(
        with labelText: String,
        backgroundImage: UIImage
    ) -> UIViewController {
        let router = OnboardingRouter()
        let presenter = OnboardingPresenter(router: router)
        let view = OnboardingViewController(
            presenter: presenter,
            labelText: labelText,
            backgroundImage: backgroundImage
        )

        presenter.view = view

        return view
    }
}
