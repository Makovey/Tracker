//
//  CategorySelectorPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 02.02.2024.
//

import Foundation

protocol ICategorySelectorOutput: AnyObject {
    func categorySelected(_ category: String)
}

protocol ICategorySelectorPresenter {
    func addCategoryButtonTapped(existedCategory: [String])
    func categorySelected(_ category: String)
}

final class CategorySelectorPresenter {
    // MARK: - Properties
    
    private let router: any ICategorySelectorRouter
    weak var output: (any ICategorySelectorOutput)?
    weak var view: (any ICategorySelectorView)?

    // MARK: - Lifecycle

    init(router: some ICategorySelectorRouter) {
        self.router = router
    }

    // MARK: - Public

    // MARK: - Private
}

// MARK: - ICategorySelectorPresenter

extension CategorySelectorPresenter: ICategorySelectorPresenter {
    func categorySelected(_ category: String) {
        output?.categorySelected(category)
        router.popScreen()
    }
    
    func addCategoryButtonTapped(existedCategory: [String]) {
        router.openCategoryBuilderScreen(with: self, existedCategory: existedCategory)
    }
}

// MARK: - ICategoryBuilderOutput

extension CategorySelectorPresenter: ICategoryBuilderOutput {
    func getNewCategoryFromBuilder(_ category: String) {
        view?.getNewCategoryName(category)
    }
}
