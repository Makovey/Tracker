//
//  HabitsAssembly.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

final class HabitsAssembly {
    // MARK: - Public
    
    static func assemble() -> UIViewController {
        let router = HabitsRouter()
        let presenter = HabitsPresenter(router: router)
        let view = HabitsViewController(presenter: presenter)

        router.viewController = view
        presenter.view = view

        return view
    }
}
