//
//  CategorySelectorAssembly.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 02.02.2024.
//

import UIKit

final class CategorySelectorAssembly {
    // MARK: - Public
    
    static func assemble(
        navigationController: UINavigationController?,
        output: some ICategorySelectorOutput
    ) -> UIViewController {
        let router = CategorySelectorRouter()
        let storage: IPersistenceStorage = CoreDataStorage()
        let repository: ITrackerRepository = TrackerRepository(storage: storage)

        let viewModel = CategorySelectorViewModel(trackerRepository: repository, router: router)
        viewModel.output = output

        let view = CategorySelectorViewController(
            viewModel: viewModel
        )

        router.viewController = navigationController

        return view
    }
}
