//
//  TrackersViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

typealias TrackersSnapshot = NSDiffableDataSourceSnapshot<String, Tracker>
typealias TrackersDataSource = UICollectionViewDiffableDataSource<String, Tracker>

protocol ITrackersView: AnyObject { }

final class TrackersViewController: UIViewController {
    private enum Constant {
        static let dayInSeconds: TimeInterval = 86400
    }
    
    // MARK: - Properties

    private let presenter: any ITrackersPresenter
    private let layoutProvider: any ILayoutProvider

    private var fullCategoryList = [TrackerCategory]()
    private var visibleCategoryList = [TrackerCategory]() {
        didSet { reloadSnapshot() }
    }
    private var completedTrackers = [TrackerRecord]()
    private var chosenDate = Date()
        
    private lazy var dataSource: TrackersDataSource = {
        let dataSource = TrackersDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, tracker in
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
        label.text = "Что будем отслеживать?" // TODO: Localization
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

        return datePicker.forAutolayout()
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
        navigationItem.hidesSearchBarWhenScrolling = false
        
        datePicker.width.constraint(equalToConstant: 100).isActive = true
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
    
        updateCategoriesForChosenDate()
    }
    
    private func showEmptyState() {
        emptyStateView.placedOn(collectionView)

        NSLayoutConstraint.activate([
            emptyStateView.centerX.constraint(equalTo: collectionView.centerX),
            emptyStateView.centerY.constraint(equalTo: collectionView.centerY)
        ])
    }
    
    private func hideEmptyState() {
        emptyStateView.removeFromSuperview()
    }

    private func reloadSnapshot() {
        var snapshot = TrackersSnapshot()
        
        visibleCategoryList.forEach {
            snapshot.appendSections([$0.header])
            snapshot.appendItems($0.trackers, toSection: $0.header)
        }

        snapshot.numberOfItems == .zero ? showEmptyState() : hideEmptyState()
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
        
        let isEditingAvailable = Calendar.current.compare(chosenDate, to: Date(), toGranularity: .day) != .orderedDescending
        
        let isCompletedForToday = completedTrackers
            .filter { isTrackerCompletedForToday(record: $0, id: tracker.id) }
            .count != 0

        let model = TrackersCell.Model(
            tracker: tracker,
            isCompletedForToday: isCompletedForToday,
            completedTimes: completedTrackers.filter { $0.id == tracker.id }.count,
            isEditingAvailable: isEditingAvailable
        )
        
        cell.configure(with: model)
        cell.delegate = self

        return cell
    }
    
    private func isTrackerCompletedForToday(record: TrackerRecord, id: UUID) -> Bool {
        guard record.id == id else { return false }
        return Calendar.current.compare(chosenDate, to: record.endDate, toGranularity: .day) == .orderedSame
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
        
        let modelForSection = self.visibleCategoryList[indexPath.section]
        header.configure(for: modelForSection)
        
        return header
    }
    
    private func updateCategoriesForChosenDate() {
        let filteredWeekday = Calendar.current.component(.weekday, from: chosenDate)
        
        visibleCategoryList.removeAll()
        visibleCategoryList = fullCategoryList.compactMap {
            let trackers = $0.trackers.filter {
                $0.schedule.contains {
                    $0.dayInt == filteredWeekday
                }
            }

            guard !trackers.isEmpty else { return nil }

            return .init(
                header: $0.header,
                trackers: trackers
            )
        }
    }
    
    @objc
    private func addTrackerButtonTapped() {
        presenter.addTrackerButtonTapped()
    }
    
    @objc
    func datePickerValueChanged(_ sender: UIDatePicker) {
        chosenDate = sender.date
        updateCategoriesForChosenDate()
    }
}

// MARK: - ITrackerView

extension TrackersViewController: ITrackersView { }

// MARK: - UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print("\(#function) with text \(text)")
    }
}

// MARK: - ITrackersCellDelegate

extension TrackersViewController: ITrackersCellDelegate {
    func doneButtonTapped(with id: UUID, state: Bool) {
        let trackerRecord = TrackerRecord(id: id, endDate: chosenDate)
        if state {
            completedTrackers.append(trackerRecord)
        } else {
            completedTrackers = completedTrackers.filter { $0.id != trackerRecord.id }
        }
    }
}

// MARK: - Mock/Debug data

extension TrackersViewController {
    private func addMockData() {
        fullCategoryList = [
            .init(header: "Отдых", trackers: [
                .init(
                    name: "Погулять",
                    color: .primaryGreen,
                    emoji: "🚶",
                    schedule: [.sunday, .thursday]),
                .init(
                    name: "Покататься на велосипеде",
                    color: .primaryOrange,
                    emoji: "🚴",
                    schedule: [.saturday]),
                .init(
                    name: "Почитать книгу",
                    color: .primaryRed,
                    emoji: "📙",
                    schedule: [.friday, .wednesday])
            ]),
            .init(header: "Работа", trackers: [
                .init(
                    name: "Закрыть задачу",
                    color: .primaryLightBlue,
                    emoji: "👷",
                    schedule: [.monday])
            ]),
            .init(header: "Поездка", trackers: [
                .init(
                    name: "Забронировать отель",
                    color: .primaryLightGreen,
                    emoji: "🏢",
                    schedule: [.wednesday])
            ])
        ]
    }
}
