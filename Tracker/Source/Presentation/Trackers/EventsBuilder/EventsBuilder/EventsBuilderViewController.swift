//
//  EventsBuilderViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 25.01.2024.
//

import UIKit

typealias BuilderSnapshot = NSDiffableDataSourceSnapshot<BuilderSection, String>
typealias BuilderDataSource = UICollectionViewDiffableDataSource<BuilderSection, String>

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
    
    struct TrackerToFill {
        let trackerName: String?
        let categoryName: String?
        let schedule: Set<WeekDay>?
        let selectedEmoji: String?
        let selectedColor: UIColor?
    }
    
    private enum NavigationItem {
        case category
        case schedule
    }

    // MARK: - Properties

    private var trackerName: String? {
        didSet { checkAvailability() }
    }
    
    private var categoryName: String? {
        didSet { checkAvailability() }
    }
    
    private var schedule: Set<WeekDay>? {
        didSet { checkAvailability() }
    }
    
    private var selectedEmoji: String? {
        didSet { checkAvailability() }
    }
    private var selectedColor: UIColor? {
        didSet { checkAvailability() }
    }
    
    private let layoutProvider: any ILayoutProvider
    private let presenter: any IEventsBuilderPresenter
    private var navigationItems: [NavigationItem] = [.category]
    private let mode: EventType
    
    private lazy var dataSource: BuilderDataSource = {
        let dataSource = BuilderDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self else { fatalError("\(EventsBuilderViewController.self) is nil") }
            return self.cellProvider(collectionView: collectionView, indexPath: indexPath, item: item)
        }

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { fatalError("\(EventsBuilderViewController.self) is nil") }
            return self.supplementaryViewProvider(collection: collectionView, kind: kind, indexPath: indexPath)
        }

        return dataSource
    }()
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layoutProvider.layout()
        )
        
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.register(EmojiCell.self)
        collectionView.register(ColorCell.self)
        collectionView.register(
            PrimarySupplementaryHeader.self,
            of: UICollectionView.elementKindSectionHeader
        )
        
        return collectionView.forAutolayout()
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Assets.primaryElementBackground.color
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
        mode: EventType,
        presenter: some IEventsBuilderPresenter,
        layoutProvider: some ILayoutProvider
    ) {
        self.mode = mode
        self.presenter = presenter
        self.layoutProvider = layoutProvider
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
        
        collectionView.placedOn(view)
        NSLayoutConstraint.activate([
            collectionView.top.constraint(equalTo: tableView.bottom, constant: 24),
            collectionView.left.constraint(equalTo: view.left),
            collectionView.right.constraint(equalTo: view.right),
            collectionView.bottom.constraint(equalTo: stackView.top, constant: -Constant.baseInset)
        ])
    }
    
    private func setupInitialState() {
        hideKeyboardWhenTappedAround()
        
        collectionView.dataSource = dataSource
        reloadSnapshot()
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
        guard 
            let trackerName,
            categoryName != nil,
            let selectedEmoji,
            let selectedColor
        else { return }

        let tracker = Tracker(
            id: .init(), 
            name: trackerName,
            color: selectedColor,
            emoji: selectedEmoji,
            schedule: schedule
        )
        
        presenter.createButtonTapped(with: tracker)
    }
    
    private func checkAvailability() {
        let trackerToFill = TrackerToFill(
            trackerName: trackerName,
            categoryName: categoryName,
            schedule: schedule,
            selectedEmoji: selectedEmoji,
            selectedColor: selectedColor
        )
        
        if presenter.canCreateFilledTracker(mode: mode, trackerToFill: trackerToFill) {
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
        let cell: PrimaryCell = tableView.dequeueCell(for: indexPath)

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

// MARK: UICollectionView

extension EventsBuilderViewController {
    private func reloadSnapshot() {
        var snapshot = BuilderSnapshot()
        
        snapshot.appendSections(BuilderSection.allCases)
        snapshot.appendItems(BuilderDataProvider.emojis, toSection: .emoji)
        snapshot.appendItems(BuilderDataProvider.colors, toSection: .color)
        
        dataSource.apply(snapshot)
    }
    
    private func cellProvider(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: String
    ) -> UICollectionViewCell {
        if let colorItem = UIColor(hex: item) {
            let cell: ColorCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(color: colorItem)
            return cell
        } else {
            let cell: EmojiCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(emoji: item)
            return cell
        }
    }
    
    private func supplementaryViewProvider(
        collection: UICollectionView,
        kind: String,
        indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header: PrimarySupplementaryHeader = collectionView.dequeueSupplementary(
            kind: UICollectionView.elementKindSectionHeader,
            for: indexPath
        )
        let title = BuilderSection.allCases[indexPath.section].rawValue
        header.configure(title: title)
        
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension EventsBuilderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.cellForItem(at: indexPath) {
        case let emojiCell as EmojiCell:
            selectedEmoji = emojiCell.emoji
        case let colorCell as ColorCell:
            selectedColor = colorCell.mainColor
        default: break
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView
            .indexPathsForSelectedItems?
            .filter { $0.section == indexPath.section }
            .forEach { collectionView.deselectItem(at: $0, animated: false) }
        return true
    }
}
