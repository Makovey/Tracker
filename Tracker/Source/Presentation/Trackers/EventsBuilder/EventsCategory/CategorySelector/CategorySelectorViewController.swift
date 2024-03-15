//
//  CategorySelectorViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 02.02.2024.
//

import UIKit

enum Section { case main }

typealias CategoriesSnapshot = NSDiffableDataSourceSnapshot<Section, String>
typealias CategoriesDataSource = UITableViewDiffableDataSource<Section, String>

protocol ICategorySelectorView: AnyObject { }

final class CategorySelectorViewController: UIViewController {
    private enum Constant {
        static let baseInset: CGFloat = 16
        static let baseCornerRadius: CGFloat = 16
        static let cellsHeight: CGFloat = 75
    }
    
    // MARK: - Properties
    
    private var viewModel: any ICategorySelectorViewModel
    private var categories = [String]() {
        didSet { reloadSnapshot() }
    }
    
    private var selectedCategory: String?
    
    private lazy var dataSource: CategoriesDataSource = {
        CategoriesDataSource(tableView: tableView) { [weak self] tableView, indexPath, category in
            guard let self else { fatalError("\(CategorySelectorViewController.self) is nil") }
            return self.cellProvider(tableView: tableView, indexPath: indexPath, category: category)
        }
    }()
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = Constant.baseCornerRadius
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.register(PrimaryCell.self, forCellReuseIdentifier: PrimaryCell.identifier)
        
        return tableView.forAutolayout()
    }()
    
    private lazy var addCategoryButton: PrimaryButton = {
        let button = PrimaryButton(style: .enabled, text: .loc.Category.Selector.PrimaryButton.title)
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        
        return button.forAutolayout()
    }()
    
    private lazy var emptyStateView: StatusView = {
        StatusView(
            model: .init(
                labelText: .loc.Category.Selector.EmptyState.title,
                image: Assets.emptyTrackerImage.image
            )
        ).forAutolayout()
    }()

    // MARK: - Lifecycle

    init(viewModel: some ICategorySelectorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupInitialState()
    }

    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.setHidesBackButton(true, animated: true)

        title = .loc.Events.Builder.CategoryCell.title

        addCategoryButton.placedOn(view)
        NSLayoutConstraint.activate([
            addCategoryButton.left.constraint(equalTo: view.left, constant: 20),
            addCategoryButton.right.constraint(equalTo: view.right, constant: -20),
            addCategoryButton.bottom.constraint(equalTo: view.safeBottom, constant: -Constant.baseInset),
            addCategoryButton.height.constraint(equalToConstant: 60)
        ])
        
        tableView.placedOn(view)
        NSLayoutConstraint.activate([
            tableView.top.constraint(equalTo: view.safeTop, constant: Constant.baseInset),
            tableView.left.constraint(equalTo: view.left, constant: Constant.baseInset),
            tableView.right.constraint(equalTo: view.right, constant: -Constant.baseInset),
            tableView.bottom.constraint(equalTo: addCategoryButton.top, constant: -20)
        ])
    }
    
    private func setupInitialState() {
        viewModel.selectedCategoryBinding = { [weak self] in
            self?.selectedCategory = $0
        }

        viewModel.categoriesNamesBinding = { [weak self] in
            self?.categories = $0
            self?.tableView.reloadData()
        }

        tableView.dataSource = dataSource
    }
    
    private func reloadSnapshot() {
        var snapshot = CategoriesSnapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(categories)
        
        snapshot.numberOfItems == .zero ? showEmptyState() : hideEmptyState()
        dataSource.apply(snapshot)
    }
    
    private func showEmptyState() {
        emptyStateView.placedOn(view)

        NSLayoutConstraint.activate([
            emptyStateView.centerX.constraint(equalTo: view.centerX),
            emptyStateView.centerY.constraint(equalTo: view.centerY)
        ])
    }
    
    private func hideEmptyState() {
        emptyStateView.removeFromSuperview()
    }
    
    private func cellProvider(
        tableView: UITableView,
        indexPath: IndexPath,
        category: String
    ) -> UITableViewCell {
        let cell: PrimaryCell = tableView.dequeueCell(for: indexPath)

        cell.selectionStyle = .none
        cell.configure(
            title: category,
            accessory: .checkmark,
            isLastCell: indexPath.row == categories.count - 1
        )

        if category == selectedCategory { cell.didSelect() }

        return cell
    }
    
    @objc
    private func addCategoryButtonTapped() { 
        viewModel.addCategoryButtonTapped()
    }
}

// MARK: - UITableViewDelegate

extension CategorySelectorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.cellsHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(
            at: indexPath
        ) as? PrimaryCell else { return }
        
        cell.didSelect()
        viewModel.saveAllCreatedCategories(categories)
        viewModel.categorySelected(categories[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(
            at: indexPath
        ) as? PrimaryCell else { return }
        
        cell.didDeselect()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if categories[indexPath.row] == selectedCategory {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

// MARK: - ICategorySelectorInput

extension CategorySelectorViewController: ICategorySelectorInput {
    func setSelectedCategory(category: String?) {
        guard let category else { return }
        viewModel.saveSelectedCategoryName(category)
    }
}
