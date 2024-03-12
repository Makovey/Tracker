//
//  CategorySelectorViewModel.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 27.02.2024.
//

import Foundation

protocol ICategorySelectorViewModel {
    var categoriesNamesBinding: Binding<[String]>? { get set }
    var selectedCategoryBinding: Binding<String?>? { get set }

    func saveAllCreatedCategories(_ categories: [String])
    func categorySelected(_ category: String)

    func addCategoryButtonTapped()
    func saveSelectedCategoryName(_ categoryName: String)
}

final class CategorySelectorViewModel: ICategorySelectorViewModel {
    // MARK: - Properties

    weak var output: (any ICategorySelectorOutput)?

    var categoriesNamesBinding: Binding<[String]>? {
        didSet { categoriesNamesBinding?(trackerRepository.fetchAllCategories().map { $0.header }) }
    }

    var selectedCategoryBinding: Binding<String?>? {
        didSet { selectedCategoryBinding?(trackerRepository.fetchSelectedCategoryName()) }
    }

    private var categoriesNames = [String]() {
        didSet { categoriesNamesBinding?(categoriesNames) }
    }

    private let trackerRepository: any ITrackerRepository
    private let router: any ICategorySelectorRouter

    // MARK: - Lifecycle

    init(
        trackerRepository: some ITrackerRepository,
        router: some ICategorySelectorRouter
    ) {
        self.trackerRepository = trackerRepository
        self.router = router
    }

    func saveAllCreatedCategories(_ categories: [String]) {
        trackerRepository.saveAllCategories(categories)
    }

    func categorySelected(_ category: String) {
        output?.categorySelected(category)
        router.popScreen()
    }

    func addCategoryButtonTapped() {
        router.openCategoryBuilderScreen(with: self, existedCategory: categoriesNames)
    }

    func saveSelectedCategoryName(_ categoryName: String) {
        trackerRepository.saveSelectedCategoryName(categoryName)
    }
}

// MARK: - ICategoryBuilderOutput

extension CategorySelectorViewModel: ICategoryBuilderOutput {
    func didBuildNewCategory(_ category: String) {
        trackerRepository.saveAllCategories([category])
        categoriesNamesBinding?(trackerRepository.fetchAllCategories().map { $0.header })
    }
}
