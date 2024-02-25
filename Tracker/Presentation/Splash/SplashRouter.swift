//
//  SplashRouter.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 25.02.2024
//

import UIKit

protocol ISplashRouter { 
    func openOnboardingScreen()
    func openMainScreen()
}

final class SplashRouter: ISplashRouter {
    // MARK: - Public

    func openOnboardingScreen() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Can't find first window")
            return
        }

        let tabBar = OnboardingManagerAssembly.assemble()
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }

    func openMainScreen() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Can't find first window")
            return
        }

        let tabBar = TabBarController()
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
}
