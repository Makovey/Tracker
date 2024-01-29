//
//  TrackersViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

typealias Snapshot = NSDiffableDataSourceSnapshot<String, Tracker>
typealias DataSource = UICollectionViewDiffableDataSource<String, Tracker>

protocol ITrackersView: AnyObject { }

final class TrackersViewController: UIViewController {
    private enum Constant {
        static let dayInSeconds: TimeInterval = 86400
    }
    
    // MARK: - Properties

    private let presenter: any ITrackersPresenter
    private let layoutProvider: any ILayoutProvider

    private var categories = [TrackerCategory]()
    private var completedTrackers = [TrackerRecord]()
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, tracker in
            guard let self else { fatalError("TrackersViewController is nil") }
            return self.cellProvider(collectionView: collectionView, indexPath: indexPath, tracker: tracker)
        }

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { fatalError("TrackersViewController is nil") }
            return self.supplementaryViewProvider(collection: collectionView, kind: kind, indexPath: indexPath)
        }

        return dataSource
    }()
    
    // MARK: - UI
        
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTrackerButtonTapped)
        )
        
        button.tintColor = .label
        
        return button
    }()
    
    private lazy var searchInput: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Поиск" // TODO: Localization
        
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutProvider.layout())
        
        collectionView.register(TrackersCell.self, forCellWithReuseIdentifier: TrackersCell.identifier)
        collectionView.register(
            TrackersSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackersSupplementaryView.identifier
        )
        
        return collectionView.forAutolayout()
    }()
    
    private lazy var emptyStateView: UIStackView = {
        let imageView = UIImageView(image: .emptyImage)
        imageView.frame = .init(x: 0, y: 0, width: 80, height: 80)
        
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12)

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = .init(integerLiteral: 8)
        
        return stackView.forAutolayout()
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

        return datePicker
    }()

    // MARK: - Lifecycle

    init(
        presenter: some ITrackersPresenter,
        layoutProvider: some ILayoutProvider
    ) {
        self.presenter = presenter
        self.layoutProvider = layoutProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        addMockData()
        setupUI()
        setupInitialState()
    }

    // MARK: - Private

    private func setupUI() {
        navigationItem.leftBarButtonItem = addButton
        navigationItem.searchController = searchInput
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        collectionView.placedOn(view)
        NSLayoutConstraint.activate([
            collectionView.top.constraint(equalTo: view.safeTop, constant: 12),
            collectionView.left.constraint(equalTo: view.left),
            collectionView.right.constraint(equalTo: view.right),
            collectionView.bottom.constraint(equalTo: view.safeBottom)
        ])
    }
    
    private func setupInitialState() {
        collectionView.dataSource = dataSource
    
        reloadSnapshot()
    }
    
    private func showEmptyState() {
        emptyStateView.placedOn(collectionView)

        NSLayoutConstraint.activate([
            emptyStateView.centerX.constraint(equalTo: collectionView.centerX),
            emptyStateView.centerY.constraint(equalTo: collectionView.centerY)
        ])
    }

    private func reloadSnapshot() {
        var snapshot = Snapshot()
        
        categories.forEach {
            snapshot.appendSections([$0.header])
            snapshot.appendItems($0.trackers)
        }

        dataSource.apply(snapshot)
    }
    
    private func cellProvider(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        tracker: Tracker
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersCell.identifier,
            for: indexPath
        ) as? TrackersCell else { return UICollectionViewCell() }

        let modelForCell = tracker
        cell.configure(for: modelForCell)

        return cell
    }
    
    private func supplementaryViewProvider(
        collection: UICollectionView,
        kind: String,
        indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackersSupplementaryView.identifier, for: indexPath
        ) as? TrackersSupplementaryView else { return UICollectionReusableView() }
        
        let modelForSection = self.categories[indexPath.section]
        header.configure(for: modelForSection)
        
        return header
    }
    
    private func hideEmptyState() {
        emptyStateView.removeFromSuperview()
    }
    
    @objc
    private func addTrackerButtonTapped() {
        presenter.addTrackerButtonTapped()
    }
    
    @objc
    func datePickerValueChanged(_ sender: UIDatePicker) {
        print(sender.date)
    }
}

// MARK: - ITrackerView

extension TrackersViewController: ITrackersView { }

// MARK: - UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}

// MARK: - Mock/Debug data

extension TrackersViewController {
    private func addMockData() {
        categories = [
            .init(header: "Отдых", trackers: [
                .init(id: .init(), name: "Погулять", color: .greenCard, emoji: "🚶", schedule: [.init(), .init(timeIntervalSinceNow: Constant.dayInSeconds)]),
                .init(id: .init(), name: "Покататься на велосипеде", color: .orangeCard, emoji: "🚴", schedule: [.init(timeIntervalSinceNow: Constant.dayInSeconds)]),
                .init(id: .init(), name: "Почитать книгу", color: .redCard, emoji: "📙", schedule: [.init(), .init(timeIntervalSinceNow: Constant.dayInSeconds)])
            ]),
            .init(header: "Работа", trackers: [
                .init(id: .init(), name: "Закрыть задачу", color: .lightBlueCard, emoji: "👷", schedule: [.init(timeIntervalSinceNow: Constant.dayInSeconds * 2)])
            ]),
            .init(header: "Поездка", trackers: [
                .init(id: .init(), name: "Забронировать отель", color: .lightGreenCard, emoji: "🏢", schedule: [.init(timeIntervalSinceNow: Constant.dayInSeconds * 3)])
            ])
        ]
    }
}
