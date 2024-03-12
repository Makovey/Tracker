//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

protocol IStatisticsView: AnyObject {
    func updateStatistics(with models: [StatisticsCell.Model])
}

final class StatisticsViewController: UIViewController {
    private enum Constant {
        static let sideInset: CGFloat = 16
        static let extraSideInset: CGFloat = 24
        static let cellsHeight: CGFloat = 90
        static let cellBottomInset: CGFloat = 12
    }
    // MARK: - Properties

    private let presenter: any IStatisticsPresenter
    private var statisticsModels = [StatisticsCell.Model]()

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StatisticsCell.self)

        return tableView.forAutolayout()
    }()

    private lazy var statusView: StatusView = {
        StatusView(
            model: .init(
                labelText: .loc.Statistics.EmptyState.title,
                image: Assets.emptyStatistics.image
            )
        ).forAutolayout()
    }()

    // MARK: - Lifecycle

    init(presenter: some IStatisticsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }

    // MARK: - Private

    private func setupUI() {
        tableView.placedOn(view)
        NSLayoutConstraint.activate([
            tableView.top.constraint(equalTo: view.top, constant: Constant.extraSideInset),
            tableView.left.constraint(equalTo: view.left, constant: Constant.sideInset),
            tableView.right.constraint(equalTo: view.right, constant: -Constant.sideInset),
            tableView.bottom.constraint(equalTo: view.bottom, constant: -Constant.extraSideInset),
        ])

        statusView
            .placedOn(view)
            .pinToCenter(of: view)
    }

    private func showStatusView() {
        statusView.isHidden = false
        tableView.isHidden = true
    }

    private func hideStatusView() {
        statusView.isHidden = true
        tableView.isHidden = false
    }
}

// MARK: - IStatisticsView

extension StatisticsViewController: IStatisticsView {
    func updateStatistics(with models: [StatisticsCell.Model]) {
        statisticsModels = models

        if statisticsModels.isEmpty {
            showStatusView()
        } else {
            hideStatusView()
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statisticsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StatisticsCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: statisticsModels[indexPath.row])
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.cellsHeight + Constant.cellBottomInset
    }
}

