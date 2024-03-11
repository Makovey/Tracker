//
//  FilterPresenter.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 11.03.2024
//

import Foundation

protocol IFilterPresenter { 
    func filterSelected(filterType: FilterType)
}

final class FilterPresenter {
    // MARK: - Properties

    private let router: any IFilterRouter
    weak var output: (any IFilterOutput)?
    weak var view: (any IFilterView)?

    // MARK: - Lifecycle

    init(
        router: some IFilterRouter
    ) {
        self.router = router
    }

    // MARK: - Public

    func filterSelected(filterType: FilterType) {
        output?.filterSelected(filterType)
        router.popScreen()
    }

    // MARK: - Private
}

// MARK: - IFilterPresenter

extension FilterPresenter: IFilterPresenter { }
