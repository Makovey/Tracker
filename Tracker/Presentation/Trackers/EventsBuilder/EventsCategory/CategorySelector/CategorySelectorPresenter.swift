//
//  CategorySelectorPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 02.02.2024.
//

import Foundation

protocol ICategorySelectorPresenter {
    func addCategoryButtonTapped(existedCategory: [String])
    func categorySelected(_ category: String)
}

final class CategorySelectorPresenter: ICategorySelectorPresenter {
    // MARK: - Properties
    
    weak var output: (any ICategorySelectorOutput)?
    weak var view: (any ICategorySelectorView)?
    private let router: any ICategorySelectorRouter

    // MARK: - Lifecycle

    init(router: some ICategorySelectorRouter) {
        self.router = router
    }

    // MARK: - Public
    
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
    func didBuildNewCategory(_ category: String) {
        view?.updateCategory(category)
    }
}
