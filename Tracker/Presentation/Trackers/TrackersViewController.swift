//
//  TrackersViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

protocol ITrackersView: AnyObject { }

final class TrackersViewController: UIViewController {
    // Dependencies

    private let presenter: ITrackersPresenter

    // MARK: - Initialization

    init(presenter: ITrackersPresenter) {
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
        view.backgroundColor = .green
    }
}

// MARK: - ITrackerView

extension TrackersViewController: ITrackersView { }
