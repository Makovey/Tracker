//
//  EventsBuilderViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 25.01.2024.
//

import UIKit

protocol IEventsBuilderView: AnyObject { }

final class EventsBuilderViewController: UIViewController {
    private enum Constant {
        static let baseInset: CGFloat = 16
        static let baseCornerRadius: CGFloat = 16
        
        static let cellsHeight: CGFloat = 75
    }
    
    private enum NavigationItem {
        case category
        case schedule
    }

    // MARK: - Properties

    private let presenter: any IEventsBuilderPresenter
    private let mode: EventMode
    private let navigationItems: [NavigationItem] = [.category, .schedule]
    
    // MARK: - UI
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .primaryElementBackground
        textField.placeholder = "Введите название трекера" // TODO: Localization
        textField.clearButtonMode = .whileEditing

        textField.font = .systemFont(ofSize: 17)
        textField.layer.cornerRadius = Constant.baseCornerRadius
        
        let paddingView: UIView = .init(frame: .init(
            x: .zero,
            y: .zero,
            width: Constant.baseInset,
            height: .zero)
        )

        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField.forAutolayout()
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = Constant.baseCornerRadius
        tableView.isScrollEnabled = false

        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(
            top: .zero,
            left: Constant.baseInset,
            bottom: .zero,
            right: Constant.baseInset
        )

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PrimaryCell.self, forCellReuseIdentifier: PrimaryCell.identifier)
        
        return tableView.forAutolayout()
    }()

    // MARK: - Lifecycle

    init(
        presenter: some IEventsBuilderPresenter,
        mode: EventMode
    ) {
        self.presenter = presenter
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }


    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.setHidesBackButton(true, animated: true)

        switch mode {
        case .habit:
            title = "Новая привычка" // TODO: Localization
        case .event:
            title = "Новое нерегулярное событие" // TODO: Localization
        }
        
        textField.placedOn(view)
        NSLayoutConstraint.activate([
            textField.top.constraint(equalTo: view.safeTop, constant: 24),
            textField.left.constraint(equalTo: view.left, constant: Constant.baseInset),
            textField.right.constraint(equalTo: view.right, constant: -Constant.baseInset),
            textField.height.constraint(equalToConstant: Constant.cellsHeight)
        ])
        
        tableView.placedOn(view)
        NSLayoutConstraint.activate([
            tableView.top.constraint(equalTo: textField.bottom, constant: 24),
            tableView.left.constraint(equalTo: view.left, constant: Constant.baseInset),
            tableView.right.constraint(equalTo: view.right, constant: -Constant.baseInset),
            tableView.height.constraint(equalToConstant: Constant.cellsHeight * CGFloat(navigationItems.count))
        ])
    }
}

// MARK: - IEventsBuilderView

extension EventsBuilderViewController: IEventsBuilderView { }

// MARK: - UITableViewDelegate

extension EventsBuilderViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension EventsBuilderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        navigationItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PrimaryCell.identifier,
            for: indexPath
        ) as? PrimaryCell else { return UITableViewCell() }
        
        let title: String
        
        switch navigationItems[indexPath.row] {
        case .category:
            title = "Категория" // TODO: Localization
        case .schedule:
            title = "Расписание" // TODO: Localization
        }
        
        cell.configure(title: title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
