//
//  EventsBuilderViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 25.01.2024.
//

import UIKit

protocol IEventsBuilderView: AnyObject {
    func updateCategoryField(with category: String)
    func updateScheduleField(with schedule: Set<WeekDay>)
}

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

    private var trackerName: String? {
        didSet { checkAvailability() } // TODO: presenter.checkAvailability() ?
    }
    
    private var categoryName: String? {
        didSet { checkAvailability() }
    }
    
    private var schedule: Set<WeekDay>? {
        didSet { checkAvailability() }
    }

    private var isNewTrackerFilled: Bool {
        switch mode {
        case .habit:
            trackerName?.isEmpty == false &&
            categoryName?.isEmpty == false &&
            schedule?.isEmpty == false
        case .event:
            trackerName?.isEmpty == false &&
            categoryName?.isEmpty == false
        }
    }
    
    private let presenter: any IEventsBuilderPresenter
    private let mode: EventType
    private var navigationItems: [NavigationItem] = [.category]
    
    // MARK: - UI
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .primaryElementBackground
        textField.placeholder = "events.builder.textField.placeholder".localized
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done

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
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        textField.delegate = self
        
        return textField.forAutolayout()
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = Constant.baseCornerRadius
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PrimaryCell.self, forCellReuseIdentifier: PrimaryCell.identifier)
        
        return tableView.forAutolayout()
    }()
    
    private lazy var cancelButton: PrimaryButton = {
        let cancelButton = PrimaryButton(style: .canceled, text: "events.builder.cancelButton.title".localized)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        return cancelButton
    }()
    
    private lazy var createButton: PrimaryButton = {
        let createButton = PrimaryButton(style: .disabled, text: "events.builder.createButton.title".localized)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        return createButton
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        return stackView.forAutolayout()
    }()
    

    // MARK: - Lifecycle

    init(
        presenter: some IEventsBuilderPresenter,
        mode: EventType
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
        setupInitialState()
    }

    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.setHidesBackButton(true, animated: true)

        switch mode {
        case .habit:
            title = "events.builder.habitScreen.title".localized
            navigationItems.append(.schedule)
        case .event:
            title = "events.builder.irregularEventScreen.title".localized
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
        
        stackView.placedOn(view)
        NSLayoutConstraint.activate([
            stackView.left.constraint(equalTo: view.left, constant: 20),
            stackView.right.constraint(equalTo: view.right, constant: -20),
            stackView.bottom.constraint(equalTo: view.safeBottom),
            stackView.height.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupInitialState() {
        hideKeyboardWhenTappedAround()
    }
    
    @objc
    private func textFieldValueChanged(_ sender: UITextField) {
        trackerName = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @objc
    private func cancelButtonTapped() {
        presenter.cancelButtonTapped()
    }
    
    @objc
    private func createButtonTapped() {
        guard let trackerName, categoryName != nil else { return }
        let tracker = Tracker(
            name: trackerName,
            color: .primaryOrange,
            emoji: "🤷‍♂️",
            schedule: schedule
        )
        
        presenter.createButtonTapped(with: tracker)
    }
    
    private func checkAvailability() {
        if isNewTrackerFilled {
            UIView.animate(withDuration: 0.3) {
                self.createButton.enable()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.createButton.disable()
            }
        }
    }
}

// MARK: - IEventsBuilderView

extension EventsBuilderViewController: IEventsBuilderView {
    func updateCategoryField(with category: String) {
        categoryName = category
        tableView.reloadData()
    }
    
    func updateScheduleField(with schedule: Set<WeekDay>) {
        self.schedule = schedule
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension EventsBuilderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigationItem = navigationItems[indexPath.row]
        
        switch navigationItem {
        case .category:
            presenter.categoryTapped()
        case .schedule:
            presenter.scheduleTapped()
        }
    }
}

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
        
        if indexPath.row == navigationItems.count - 1 {
            cell.separatorInset = .init(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        let title: String
        
        switch navigationItems[indexPath.row] {
        case .category:
            title = "events.builder.categoryCell.title".localized
            cell.configure(
                title: title,
                subTitle: categoryName,
                accessory: .chevron, 
                isLastCell: indexPath.row == navigationItems.count - 1
            )
        case .schedule:
            title = "common.schedule.title".localized
            
            let scheduleString = schedule?
                .sorted(by: { $0.rawValue < $1.rawValue })
                .compactMap({ $0.shortLabel })
                .joined(separator: ", ")
            
            cell.configure(
                title: title,
                subTitle: scheduleString,
                accessory: .chevron, isLastCell: indexPath.row == navigationItems.count - 1
            )
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.cellsHeight
    }
}


// MARK: - UITextFieldDelegate

extension EventsBuilderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
     }
}
