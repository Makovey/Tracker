//
//  OnboardingPresenter.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 25.02.2024
//

import Foundation

protocol IOnboardingPresenter { }

final class OnboardingPresenter {
    // MARK: - Properties

    private let router: any IOnboardingRouter
    weak var view: (any IOnboardingView)?

    // MARK: - Lifecycle

    init(router: some IOnboardingRouter) {
        self.router = router
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - IOnboardingPresenter

extension OnboardingPresenter: IOnboardingPresenter { }
