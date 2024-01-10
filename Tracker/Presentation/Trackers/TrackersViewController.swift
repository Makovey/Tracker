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
    }
    
    // Dependencies

    private let presenter: ITrackersPresenter
    
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
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

    // MARK: - Initialization

    init(presenter: ITrackersPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        presenter.viewDidLoad()
    }

    // MARK: - Private

    private func setupUI() {
        navigationItem.leftBarButtonItem = addButton
        navigationItem.searchController = searchInput
        
        collectionView.placedOn(view)
        collectionView.pin(to: view, inset: Constant.baseInset)
    }
    
    private func showEmptyState() {
        collectionView.backgroundView = emptyStateView

        NSLayoutConstraint.activate([
            emptyStateView.centerX.constraint(equalTo: view.centerX),
            emptyStateView.centerY.constraint(equalTo: view.centerY)
        ])
    }
    
    private func hideEmptyState() {
        collectionView.backgroundView = nil
    }
    
    @objc
    private func addTapped() {
        // TODO: implement
    }
    
    private func makeBlue(indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = .blue
    }
        
    private func makeOrange(indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = .orange
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
