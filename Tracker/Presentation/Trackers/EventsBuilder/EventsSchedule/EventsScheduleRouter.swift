//
//  EventsScheduleRouter.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 29.01.2024.
//

import UIKit

protocol IEventsScheduleRouter {
    func popScreen()
}

final class EventsScheduleRouter: IEventsScheduleRouter {

    // MARK: - Properties
    
    weak var viewController: UINavigationController?

    // MARK: - Public

    func popScreen() {
        viewController?.popViewController(animated: true)
    }
}
