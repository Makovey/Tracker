//
//  FilterViewController.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 11.03.2024
//

import UIKit

protocol IFilterView: AnyObject { }

final class FilterViewController: UIViewController {
    private enum Constant {
        static let baseCornerRadius: CGFloat = 16
        static let extraInset: CGFloat = 24
        static let baseInset: CGFloat = 16
        static let cellHeight: CGFloat = 75
    }

    // MARK: - Properties

    private let presenter: any IFilterPresenter
    private let filters = FilterType.allCases
    private var selectedFilter: FilterType?

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = Constant.baseCornerRadius
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PrimaryCell.self, forCellReuseIdentifier: PrimaryCell.identifier)

        return tableView.forAutolayout()
    }()

    // MARK: - Lifecycle

    init(presenter: some IFilterPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = .loc.Trackers.Filter.title

        setupUI()
    }

    // MARK: - Private

    private func setupUI() {
        tableView.placedOn(view)
        NSLayoutConstraint.activate([
            tableView.top.constraint(equalTo: view.safeTop, constant: Constant.extraInset),
            tableView.left.constraint(equalTo: view.left, constant: Constant.baseInset),
            tableView.right.constraint(equalTo: view.right, constant: -Constant.baseInset),
            tableView.bottom.constraint(equalTo: view.bottom, constant: -Constant.baseInset),
        ])
    }
}

// MARK: - IFilterView

extension FilterViewController: IFilterView { }

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PrimaryCell = tableView.dequeueCell(for: indexPath)
        let filter = filters[indexPath.row]
        cell.selectionStyle = .none

        cell.configure(
            title: filter.title,
            accessory: .checkmark,
            isLastCell: indexPath.row == filters.count - 1
        )

        if filter == selectedFilter { cell.didSelect() }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.filterSelected(filterType: filters[indexPath.row])
    }
}

// MARK: - IFilterInput

extension FilterViewController: IFilterInput {
    func setSelectedFilter(filter: FilterType) {
        selectedFilter = filter
    }
}
