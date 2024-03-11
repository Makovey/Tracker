//
//  FilterAssembly.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 11.03.2024
//

import UIKit

final class FilterAssembly {
    // MARK: - Public

    static func assemble(output: some IFilterOutput) -> UIViewController {
        let router = FilterRouter()
        let presenter = FilterPresenter(router: router)
        let view = FilterViewController(presenter: presenter)

        router.viewController = view
        presenter.view = view
        presenter.output = output

        return view
    }
}
