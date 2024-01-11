//
//  TrackersViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

protocol ITrackersView: AnyObject { }

final class TrackersViewController: UIViewController {
    private enum Constant {
        static let baseInset: CGFloat = 16.0
        static let dayInSeconds: TimeInterval = 86400
    }
    
    // Dependencies

    private let presenter: ITrackersPresenter
    private var categories = [TrackerCategory]()
    private var completedTrackers = [TrackerRecord]()
    
    // MARK: - UI
        
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
        
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var searchInput: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Поиск" // TODO: Localization
        
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
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

    init(presenter: ITrackersPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        addMockData()
        setupUI()
        presenter.viewDidLoad()
    }

    // MARK: - Private
    private func addMockData() {
        categories = [
            .init(header: "Отдых", trackers: [
                .init(id: .init(), name: "Погулять", color: .green, emoji: "🚶", schedule: [.init(), .init(timeIntervalSinceNow: Constant.dayInSeconds)]),
                .init(id: .init(), name: "Покааться на велосипеде", color: .blue, emoji: "🚴", schedule: [.init(timeIntervalSinceNow: Constant.dayInSeconds)]),
                .init(id: .init(), name: "Почитать книгу", color: .brown, emoji: "📙", schedule: [.init(), .init(timeIntervalSinceNow: Constant.dayInSeconds)])
            ]),
            .init(header: "Работа", trackers: [
                .init(id: .init(), name: "Закрыть задачу", color: .red, emoji: "👷", schedule: [.init(timeIntervalSinceNow: Constant.dayInSeconds * 2)])
            ]),
            .init(header: "Поездка", trackers: [
                .init(id: .init(), name: "Забронировать отель", color: .cyan, emoji: "🏢", schedule: [.init(timeIntervalSinceNow: Constant.dayInSeconds * 3)])
            ])
        ]
    }

    private func setupUI() {
        navigationItem.leftBarButtonItem = addButton
        navigationItem.searchController = searchInput
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        collectionView.placedOn(view)
        
        NSLayoutConstraint.activate([
            collectionView.top.constraint(equalTo: view.safeTop),
            collectionView.left.constraint(equalTo: view.left, constant: Constant.baseInset),
            collectionView.right.constraint(equalTo: view.right, constant: -Constant.baseInset),
            collectionView.bottom.constraint(equalTo: view.safeBottom)
        ])
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
    
    @objc
    private func addTapped() {
        // TODO: implement
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

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width / 2, height: 90)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackersSupplementaryView.identifier, for: indexPath
        ) as? TrackersSupplementaryView else { return UICollectionReusableView() }
        
        let modelForSection = categories[indexPath.section]
        header.configure(for: modelForSection)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
//        let header = collectionView.dequeueReusableSupplementaryView(
//            ofKind: UICollectionView.elementKindSectionHeader,
//            withReuseIdentifier: TrackersSupplementaryView.identifier,
//            for: indexPath
//        )
//        self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
//        return header.systemLayoutSizeFitting(
//            .init(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
//            withHorizontalFittingPriority: .fittingSizeLevel,
//            verticalFittingPriority: .fittingSizeLevel
//        )
        
        return .init(width: collectionView.frame.width, height: 30)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if categories.isEmpty { showEmptyState() }

        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersCell.identifier,
            for: indexPath
        ) as? TrackersCell else { return UICollectionViewCell() }
        
        let modelForCell = categories[indexPath.section].trackers[indexPath.row]
        cell.configure(for: modelForCell)
        
        return cell
    }
}

