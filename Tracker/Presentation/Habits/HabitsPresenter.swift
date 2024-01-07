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

    private let router: IHabitsRouter
    weak var view: IHabitsView?

    // MARK: - Initialization

    init(router: IHabitsRouter) {
        self.router = router
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - IHabitsPresenter

extension HabitsPresenter: IHabitsPresenter {
    func viewDidLoad() { }
}
