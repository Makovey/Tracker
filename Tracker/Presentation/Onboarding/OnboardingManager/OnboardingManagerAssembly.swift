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
            OnboardingAssembly.assemble(with: "onboarding.first.title".localized, backgroundImage: .onboardingBlue),
            OnboardingAssembly.assemble(with: "onboarding.second.title".localized, backgroundImage: .onboardingOrange)
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
