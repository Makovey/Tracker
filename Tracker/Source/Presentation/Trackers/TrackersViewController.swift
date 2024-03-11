//
//  TrackersViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

typealias TrackersSnapshot = NSDiffableDataSourceSnapshot<String, Tracker>
typealias TrackersDataSource = UICollectionViewDiffableDataSource<String, Tracker>

protocol ITrackersView: AnyObject {
    func updateTrackerList(with trackers: [TrackerCategory])
    func updateTrackerRecordList(with records: [TrackerRecord])
}

final class TrackersViewController: UIViewController {
    private enum Constant {
        static let baseInset: CGFloat = 16

        static let filterWidth: CGFloat = 114
        static let filterHeight: CGFloat = 50
    }
    
    private enum EmptyViewError {
        case text, date
    }
    
    // MARK: - Properties

    private let presenter: any ITrackersPresenter
    private let layoutProvider: any ILayoutProvider

    private var fullCategoryList = [TrackerCategory]()
    private var visibleCategoryList = [TrackerCategory]() {
        didSet { reloadSnapshot() }
    }
    private var completedTrackers = [TrackerRecord]()
    private var emptyState: EmptyViewError = .date

    private lazy var dataSource: TrackersDataSource = {
        let dataSource = TrackersDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, tracker in
            guard let self else { fatalError("\(TrackersViewController.self) is nil") }
            return self.cellProvider(collectionView: collectionView, indexPath: indexPath, tracker: tracker)
        }

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { fatalError("\(TrackersViewController.self) is nil") }
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
        let searchController = UISearchController()
        searchController.searchBar.placeholder = .loc.Trackers.SearchBar.placeholder
        searchController.searchBar.tintColor = Assets.optionState.color
        searchController.searchBar.delegate = self
        
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutProvider.layout())
        
        collectionView.register(TrackersCell.self)
        collectionView.register(
            PrimarySupplementaryHeader.self,
            of: UICollectionView.elementKindSectionHeader
        )
        
        return collectionView.forAutolayout()
    }()
    
    private lazy var statusView: StatusView = {
        StatusView(
            model: .init(
                labelText: .loc.Trackers.EmptyState.title,
                image: Assets.emptyTrackerImage.image
            )
        ).forAutolayout()
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

        return datePicker.forAutolayout()
    }()

    private lazy var filterButton: PrimaryButton = {
        let button = PrimaryButton(style: .option, text: .loc.Trackers.Filter.title)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)

        return button.forAutolayout()
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
        
        presenter.viewDidLoad()
        setupUI()
        setupInitialState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
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

        filterButton.placedOn(view)
        NSLayoutConstraint.activate([
            filterButton.width.constraint(equalToConstant: Constant.filterWidth),
            filterButton.height.constraint(equalToConstant: Constant.filterHeight),
            filterButton.centerX.constraint(equalTo: view.centerX),
            filterButton.bottom.constraint(equalTo: view.safeBottom, constant: -Constant.baseInset)
        ])
    }
    
    private func setupInitialState() {
        collectionView.dataSource = dataSource
        updateVisibilityCategories()
    }
    
    private func showEmptyState() {
        let statusViewModel: StatusView.Model

        switch emptyState {
        case .date:
            statusViewModel = StatusView.Model(
                labelText: .loc.Trackers.EmptyState.title,
                image: Assets.emptyTrackerImage.image
            )
        case .text:
            statusViewModel = StatusView.Model(
                labelText: .loc.Trackers.NotFoundState.title,
                image: Assets.notFoundTrackerImage.image
            )
        }
        
        statusView.update(with: statusViewModel)
        statusView
            .placedOn(collectionView)
            .pinToCenter(of: collectionView)
    }
    
    private func hideEmptyState() {
        statusView.removeFromSuperview()
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
        let cell: TrackersCell = collectionView.dequeueCell(for: indexPath)
        
        let trackerRecords = completedTrackers
            .filter { presenter.isTrackerCompletedForThisDay(date: datePicker.date, record: $0, id: tracker.id) }

        let model = TrackersCell.Model(
            tracker: tracker,
            isCompletedForToday: trackerRecords.count != 0,
            completedTimes: completedTrackers.filter { $0.trackerId == tracker.id }.count,
            isEditingAvailable: presenter.isEditingAvailableForThisDay(date: datePicker.date),
            recordId: trackerRecords.first?.id
        )
        
        cell.configure(with: model)
        cell.delegate = self

        return cell
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
        
        let modelForSection = self.visibleCategoryList[indexPath.section]
        header.configure(title: modelForSection.header)
        
        return header
    }
    
    private func updateVisibilityCategories() {
        let filteredWeekday = Calendar.current.component(.weekday, from: datePicker.date)

        let searchText = (searchInput.searchBar.text?.trimmingCharacters(in: .whitespaces) ?? "").lowercased()
        
        visibleCategoryList.removeAll()
        visibleCategoryList = fullCategoryList.compactMap {
            let trackers = $0.trackers.filter {
                guard let schedule = $0.schedule else { return true }
                
                let searchCondition = searchText.isEmpty || $0.name.lowercased().contains(searchText)
                let weekDayCondition = schedule.contains {
                    $0.dayInt == filteredWeekday
                }
                
                return searchCondition && weekDayCondition
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
        emptyState = .date
        updateVisibilityCategories()
    }

    @objc
    private func filterButtonTapped() {
        presenter.filterButtonTapped()
    }
}

// MARK: - ITrackerView

extension TrackersViewController: ITrackersView {
    func updateTrackerRecordList(with records: [TrackerRecord]) {
        completedTrackers = records
    }

    func updateTrackerList(with trackers: [TrackerCategory]) {
        fullCategoryList = trackers
        updateVisibilityCategories()
    }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        emptyState = .text
        updateVisibilityCategories()
    }
}

// MARK: - ITrackersCellDelegate

extension TrackersViewController: ITrackersCellDelegate {
    func doneButtonTapped(
        with trackerId: UUID,
        recordId: UUID?,
        state: Bool
    ) {
        if state {
            let trackerRecord = TrackerRecord(id: .init(), trackerId: trackerId, endDate: datePicker.date)
            presenter.doneButtonTapped(with: trackerRecord)
            completedTrackers.append(trackerRecord)
        } else {
            let id = presenter.deleteCategoryRecord(id: recordId)
            completedTrackers = completedTrackers.filter { $0.id != id }
        }
    }
}
