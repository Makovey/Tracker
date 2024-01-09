//
//  HabitsViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

protocol IHabitsView: AnyObject { }

final class HabitsViewController: UIViewController {
    // Dependencies

    private let presenter: IHabitsPresenter

    // MARK: - Initialization

    init(presenter: IHabitsPresenter) {
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

extension HabitsViewController: IHabitsView { }
