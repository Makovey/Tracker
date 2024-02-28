//
//  OnboardingManagerRouter.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 25.02.2024
//

import UIKit

protocol IOnboardingManagerRouter { 
    func openMainScreen()
}

final class OnboardingManagerRouter: IOnboardingManagerRouter {

    // MARK: - Public

    func openMainScreen() {
        guard let window = UIApplication.shared.windows.first else { 
            assertionFailure("Can't find first window")
            return
        }

        let tabBar = TabBarController()
        window.rootViewController = tabBar
        window.makeKeyAndVisible()

        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
    }

    // MARK: - Private
}
