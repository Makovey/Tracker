//
//  CategoryBuilderPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 03.02.2024.
//

import Foundation

protocol ICategoryBuilderOutput: AnyObject {
    func getNewCategoryFromBuilder(_ category: String)
}

protocol ICategoryBuilderPresenter {
    func doneButtonTapped(category: String)
}

final class CategoryBuilderPresenter {
    // MARK: - Properties
    
    private let router: any ICategoryBuilderRouter
    weak var view: (any ICategoryBuilderView)?
    weak var output: (any ICategoryBuilderOutput)?

    // MARK: - Lifecycle

    init(router: some ICategoryBuilderRouter) {
        self.router = router
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - ICategoryBuilderPresenter

extension CategoryBuilderPresenter: ICategoryBuilderPresenter {
    func doneButtonTapped(category: String) {
        router.popScreen()
        output?.getNewCategoryFromBuilder(category)
    }
}
