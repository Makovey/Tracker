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
        searchController.searchBar.placeholder = "trackers.searchBar.placeholder".localized
        searchController.searchBar.tintColor = .optionState
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
    
    private lazy var emptyStateView: UIStackView = {
        let imageView = UIImageView()
        imageView.frame = .init(x: 0, y: 0, width: 80, height: 80)
        
        let label = UILabel()
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
        
        presenter.viewDidLoad()
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
    
        updateVisibilityCategories()
    }
    
    private func showEmptyState() {
        let image: UIImage
        let title: String
        
        switch emptyState {
        case .date:
            title = "trackers.emptyState.title".localized
            image = .emptyImage
        case .text:
            title = "trackers.notFoundState.title".localized
            image = .notFoundImage
        }
        
        emptyStateView.arrangedSubviews.forEach {
            switch $0 {
            case let imageView as UIImageView:
                imageView.image = image
            case let label as UILabel:
                label.text = title
            default: break
            }
        }
        
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
        let cell: TrackersCell = collectionView.dequeueCell(for: indexPath)
        
        let isCompletedForToday = completedTrackers
            .filter { presenter.isTrackerCompletedForThisDay(date: datePicker.date, record: $0, id: tracker.id) }
            .count != 0

        let model = TrackersCell.Model(
            tracker: tracker,
            isCompletedForToday: isCompletedForToday,
            completedTimes: completedTrackers.filter { $0.id == tracker.id }.count,
            isEditingAvailable: presenter.isEditingAvailableForThisDay(date: datePicker.date)
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
    func doneButtonTapped(with id: UUID, state: Bool) {
        let trackerRecord = TrackerRecord(id: id, endDate: datePicker.date)
        if state {
            presenter.saveCategoryRecord(trackerRecord)
            completedTrackers.append(trackerRecord)
        } else {
            presenter.deleteCategoryRecord(id: id)
            completedTrackers = completedTrackers.filter { $0.id != trackerRecord.id }
        }
    }
}
