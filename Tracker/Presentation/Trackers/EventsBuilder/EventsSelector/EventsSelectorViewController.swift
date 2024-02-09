//
//  EventsSelectorViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 21.01.2024.
//

import UIKit

protocol IEventsSelectorView: AnyObject { }

final class EventsSelectorViewController: UIViewController {
    private enum Constant {
        static let sideInset: CGFloat = 20
        static let buttonsHeight: CGFloat = 60
        static let spaceBetween: CGFloat = 16
    }
    
    // MARK: - Properties
    
    private let presenter: any IEventsSelectorPresenter
    
    // MARK: - UI
    
    private lazy var stackView: UIStackView = {
        let habitButton = PrimaryButton(
            style: .enabled,
            text: "events.selector.habitButton.title".localized
        )
        let irregularEventsButton = PrimaryButton(
            style: .enabled,
            text: "events.selector.irregularEventButton.title".localized
        )
        
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        irregularEventsButton.addTarget(self, action: #selector(irregularEventsButtonTapped), for: .touchUpInside)
    
        let stackView = UIStackView(arrangedSubviews: [
            habitButton,
            irregularEventsButton
        ])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Constant.spaceBetween
        
        return stackView.forAutolayout()
    }()

    // MARK: - Lifecycle

    init(presenter: some IEventsSelectorPresenter) {
        self.presenter = presenter
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
        title = "category.selector.screen.title".localized

        stackView
            .placedOn(view)
            .pinToCenter(of: view)
        
        NSLayoutConstraint.activate([
            stackView.left.constraint(equalTo: view.left, constant: Constant.sideInset),
            stackView.right.constraint(equalTo: view.right, constant: -Constant.sideInset),
            stackView.height.constraint(equalToConstant: Constant.buttonsHeight * 2 + Constant.spaceBetween)
        ])
    }
    
    @objc
    private func habitButtonTapped() {
        presenter.habitButtonTapped()
    }
    
    @objc
    private func irregularEventsButtonTapped() {
        presenter.irregularEventsButtonTapped()
    }
}

// MARK: - IEventsSelectorView

extension EventsSelectorViewController: IEventsSelectorView { }
