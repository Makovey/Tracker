//
//  SplashPresenter.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 25.02.2024
//

import Foundation

protocol ISplashPresenter {
    func viewDidLoad()
}

final class SplashPresenter {
    // MARK: Properties

    private let router: any ISplashRouter
    private let authStorage: any IAuthStorage
    weak var view: (any ISplashView)?

    // MARK: - Lifecycle

    init(
        router: some ISplashRouter,
        authStorage: some IAuthStorage
    ) {
        self.router = router
        self.authStorage = authStorage
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - ISplashPresenter

extension SplashPresenter: ISplashPresenter {
    func viewDidLoad() { 
        authStorage.isAlreadyAuthenticated ? router.openMainScreen() : router.openOnboardingScreen()
    }
}
