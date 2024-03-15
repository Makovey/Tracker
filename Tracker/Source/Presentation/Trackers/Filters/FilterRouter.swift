//
//  FilterRouter.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 11.03.2024
//

import UIKit

protocol IFilterRouter {
    func popScreen()
}

final class FilterRouter: IFilterRouter {

    // MARK: - Properties

    weak var viewController: UIViewController?

    // MARK: - Public

    func popScreen() {
        viewController?.dismiss(animated: true)
    }

    // MARK: - Private
}
