//
//  HabitsPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import Foundation

protocol IHabitsPresenter {
    func viewDidLoad()
}

final class HabitsPresenter {
    // Dependencies

    private let router: any IHabitsRouter
    weak var view: (any IHabitsView)?

    // MARK: - Lifecycle

    init(router: some IHabitsRouter) {
        self.router = router
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - IHabitsPresenter

extension HabitsPresenter: IHabitsPresenter {
    func viewDidLoad() { }
}
