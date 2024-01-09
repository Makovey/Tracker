//
//  TabBarController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    private enum Constant {
        static let trackersImageName = "record.circle.fill"
        static let habitsImageName = "hare.fill"
    }
    
    // Dependencies
        
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
    }
    
    // MARK: = Private
    
    private func setupViewControllers() {
        let trackers = prepareViewController(
            TrackersAssembly.assemble(),
            image: .init(systemName: Constant.trackersImageName),
            title: "Трекеры" // TODO: Localization
        )
        let habits = prepareViewController(
            HabitsAssembly.assemble(),
            image: .init(systemName: Constant.habitsImageName),
            title: "Статистика"  // TODO: Localization
        )
        
        viewControllers = [trackers, habits]
    }
    
    private func prepareViewController(
        _ viewController: UIViewController,
        image: UIImage?,
        title: String
    ) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        viewController.title = title
        viewController.tabBarItem.image = image
        return navigationController
    }
}

