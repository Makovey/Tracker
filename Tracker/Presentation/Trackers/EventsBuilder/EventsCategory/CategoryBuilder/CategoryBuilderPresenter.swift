//
//  CategoryBuilderPresenter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 03.02.2024.
//

import Foundation

protocol ICategoryBuilderPresenter {
    func updateExistedCategories(_ categories: [String])
    func doneButtonTapped(category: String)
    func isValidCategoryName(_ categoryName: String) -> Bool
    func isDoneButtonEnabled(with categoryName: String?) -> Bool
}

final class CategoryBuilderPresenter: ICategoryBuilderPresenter {
    // MARK: - Properties

    weak var view: (any ICategoryBuilderView)?
    weak var output: (any ICategoryBuilderOutput)?
    
    private let router: any ICategoryBuilderRouter
    private var existedCategories = [String]()

    // MARK: - Lifecycle

    init(router: some ICategoryBuilderRouter) {
        self.router = router
    }

    // MARK: - Public
    
    func updateExistedCategories(_ categories: [String]) {
        existedCategories = categories
    }
    
    func doneButtonTapped(category: String) {
        output?.didBuildNewCategory(category)
        router.popScreen()
    }
    
    func isValidCategoryName(_ categoryName: String) -> Bool {
        existedCategories.first(where: { $0 == categoryName }) == nil
    }
    
    func isDoneButtonEnabled(with categoryName: String?) -> Bool {
        categoryName?.isEmpty == false
    }
}
