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

protocol ICategorySelectorView: AnyObject { 
    func getNewCategoryName(_ category: String)
}

final class CategorySelectorViewController: UIViewController {
    private enum Constant {
        static let baseInset: CGFloat = 16
        static let baseCornerRadius: CGFloat = 16
        static let cellsHeight: CGFloat = 75
    }
    
    // MARK: - Properties
    
    private let presenter: any ICategorySelectorPresenter
    private var categories = [String]() {
        didSet { reloadSnapshot() }
    }
    
    private lazy var dataSource: CategoriesDataSource = {
        CategoriesDataSource(tableView: tableView) { [weak self] tableView, indexPath, category in
            guard let self else { fatalError("CategorySelectorViewController is nil") }
            return self.cellProvider(tableView: tableView, indexPath: indexPath, category: category)
        }
    }()
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = Constant.baseCornerRadius

        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(
            top: .zero,
            left: Constant.baseInset,
            bottom: .zero,
            right: Constant.baseInset
        )

        tableView.delegate = self
        tableView.register(PrimaryCell.self, forCellReuseIdentifier: PrimaryCell.identifier)
        
        return tableView.forAutolayout()
    }()
    
    private lazy var addCategoryButton: PrimaryButton = {
        let button = PrimaryButton(style: .enabled, text: "Добавить категорию") // TODO: Localization
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        
        return button.forAutolayout()
    }()
    
    private lazy var emptyStateView: UIStackView = {
        let imageView = UIImageView(image: .emptyImage)
        imageView.frame = .init(x: 0, y: 0, width: 80, height: 80)
        
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Привычки и события можно\n объединить по смыслу" // TODO: Localization
        label.font = .systemFont(ofSize: 12)

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = .init(integerLiteral: 8)
        
        return stackView.forAutolayout()
    }()

    // MARK: - Initialization

    init(presenter: some ICategorySelectorPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addMockData()
        
        setupUI()
        setupInitialState()
    }

    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.setHidesBackButton(true, animated: true)

        title = "Категория" // TODO: Localization
        
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
        tableView.dataSource = dataSource
        reloadSnapshot()
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PrimaryCell.identifier,
            for: indexPath
        ) as? PrimaryCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.configure(title: category, accessory: .checkmark)

        return cell
    }
    
    private func addMockData() {
        categories = [
            "Важное",
            "Очень важное"
        ]
    }
    
    @objc
    private func addCategoryButtonTapped() { 
        presenter.addCategoryButtonTapped(existedCategory: categories)
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
        presenter.categorySelected(categories[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(
            at: indexPath
        ) as? PrimaryCell else { return }
        
        cell.didDeselect()
    }
}

// MARK: - IEventsCategoryView

extension CategorySelectorViewController: ICategorySelectorView {
    func getNewCategoryName(_ category: String) {
        categories.append(category)
    }
}
