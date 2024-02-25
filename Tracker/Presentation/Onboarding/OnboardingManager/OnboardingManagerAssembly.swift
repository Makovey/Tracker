//
//  OnboardingManagerAssembly.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 25.02.2024
//

import UIKit

final class OnboardingManagerAssembly {
    // MARK: - Public

    static func assemble() -> UIViewController {
        let onboardings = [
            OnboardingAssembly.assemble(with: "Отслеживайте только то, что хотите", backgroundImage: .onboardingBlue), // TODO: Localization
            OnboardingAssembly.assemble(with: "Даже если это не литры воды и йога", backgroundImage: .onboardingOrange) // TODO: Localization
        ]

        let router = OnboardingManagerRouter()
        let presenter = OnboardingManagerPresenter(
            router: router,
            authStorage: AuthStorage()
        )
        let view = OnboardingManagerViewController(presenter: presenter, onboardings: onboardings)

        presenter.view = view

        return view
    }
}
