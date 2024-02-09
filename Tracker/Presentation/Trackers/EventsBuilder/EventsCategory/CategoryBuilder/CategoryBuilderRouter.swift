//
//  CategoryBuilderRouter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 03.02.2024.
//

import UIKit

protocol ICategoryBuilderRouter {
    func popScreen()
}

final class CategoryBuilderRouter: ICategoryBuilderRouter {
    // MARK: - Properties
    
    weak var viewController: UINavigationController?

    // MARK: - Public

    func popScreen() {
        viewController?.popViewController(animated: true)
    }
}
