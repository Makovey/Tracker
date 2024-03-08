//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

protocol IStatisticsView: AnyObject { }

final class StatisticsViewController: UIViewController {
    // Dependencies

    private let presenter: any IStatisticsPresenter

    // MARK: - Lifecycle

    init(presenter: some IStatisticsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = .gray
    }
}

// MARK: - IHabitsView

extension StatisticsViewController: IStatisticsView { }
