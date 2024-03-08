//
//  StatisticsAssembly.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

final class StatisticsAssembly {
    // MARK: - Public
    
    static func assemble() -> UIViewController {
        let router = StatisticsRouter()
        let presenter = StatisticsPresenter(router: router)
        let view = StatisticsViewController(presenter: presenter)

        router.viewController = view
        presenter.view = view

        return view
    }
}
