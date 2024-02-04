//
//  CategorySelectorRouter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 02.02.2024.
//

import UIKit

protocol ICategorySelectorRouter { 
    func openCategoryBuilderScreen(
        with output: ICategoryBuilderOutput,
        existedCategory: [String]
    )
    
    func popScreen()
}

final class CategorySelectorRouter: ICategorySelectorRouter {

    // MARK: - Properties
    
    weak var viewController: UINavigationController?

    // MARK: - Public

    func openCategoryBuilderScreen(
        with output: ICategoryBuilderOutput,
        existedCategory: [String]
    ) {
        let destination = CategoryBuilderAssembly.assemble(navigationController: viewController, output: output)
        (destination as? ICategoryBuilderInput)?.setExistedCategories(existedCategory)
        viewController?.pushViewController(destination, animated: true)
    }
    
    func popScreen() {
        viewController?.popViewController(animated: true)
    }
}
