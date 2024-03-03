//
//  OnboardingManagerPresenter.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 25.02.2024
//

import Foundation

protocol IOnboardingManagerPresenter {
    func primaryButtonTapped()
}

final class OnboardingManagerPresenter {
    // MARK: - Properties

    private let router: any IOnboardingManagerRouter
    private var authStorage: any IAuthStorage
    weak var view: (any IOnboardingManagerView)?

    // MARK: - Lifecycle

    init(
        router: some IOnboardingManagerRouter,
        authStorage: some IAuthStorage
    ) {
        self.router = router
        self.authStorage = authStorage
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - IOnboardingManagerPresenter

extension OnboardingManagerPresenter: IOnboardingManagerPresenter {
    func primaryButtonTapped() {
        authStorage.isAlreadyAuthenticated = true
        router.openMainScreen()
    }
}
