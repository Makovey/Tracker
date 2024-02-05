//
//  CategoryBuilderAssembly.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 03.02.2024.
//

import UIKit

final class CategoryBuilderAssembly {
    // MARK: - Public
    
    static func assemble(
        navigationController: UINavigationController?,
        output: some ICategoryBuilderOutput
    ) -> UIViewController {
        let router = CategoryBuilderRouter()
        let presenter = CategoryBuilderPresenter(router: router)
        let view = CategoryBuilderViewController(presenter: presenter)

        router.viewController = navigationController
        presenter.view = view
        presenter.output = output

        return view
    }
}
