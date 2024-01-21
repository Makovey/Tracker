//
//  TrackersBuilderViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 21.01.2024.
//

import UIKit

protocol ITrackersBuilderView: AnyObject { }

final class TrackersBuilderViewController: UIViewController {
    // MARK: - Properties
    
    private let presenter: ITrackersBuilderPresenter

    // MARK: - Lifecycle

    init(presenter: ITrackersBuilderPresenter) {
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
        view.backgroundColor = .systemBackground
    }
}

// MARK: - ITrackersBuilderView

extension TrackersBuilderViewController: ITrackersBuilderView { }
