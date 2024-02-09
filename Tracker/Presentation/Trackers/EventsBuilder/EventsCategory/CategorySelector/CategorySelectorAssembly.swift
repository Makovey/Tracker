//
//  CategorySelectorAssembly.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 02.02.2024.
//

import UIKit

final class CategorySelectorAssembly {
    // MARK: - Public
    
    static func assemble(
        navigationController: UINavigationController?,
        output: some ICategorySelectorOutput
    ) -> UIViewController {
        let router = CategorySelectorRouter()
        let presenter = CategorySelectorPresenter(router: router)
        let view = CategorySelectorViewController(presenter: presenter)

        router.viewController = navigationController
        presenter.view = view
        presenter.output = output

        return view
    }
}
