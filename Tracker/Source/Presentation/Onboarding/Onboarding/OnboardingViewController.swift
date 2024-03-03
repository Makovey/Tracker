//
//  OnboardingViewController.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 25.02.2024
//

import UIKit

protocol IOnboardingView: AnyObject { }

final class OnboardingViewController: UIViewController {
    private enum Constant {
        static let baseInset: CGFloat = 16
        static let centerInset: CGFloat = 66
    }

    // MARK: - Properties

    private let presenter: any IOnboardingPresenter
    private let labelText: String
    private let backgroundImage: UIImage

    // MARK: - UI

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: backgroundImage)

        return imageView.forAutolayout()
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = labelText
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = Assets.staticBlack.color

        return label.forAutolayout()
    }()

    // MARK: - Lifecycle

    init(
        presenter: some IOnboardingPresenter,
        labelText: String,
        backgroundImage: UIImage
    ) {
        self.presenter = presenter
        self.labelText = labelText
        self.backgroundImage = backgroundImage

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
        backgroundImageView
            .placedOn(view)
            .pin(to: view)

        titleLabel.placedOn(view)
        NSLayoutConstraint.activate([
            titleLabel.centerY.constraint(equalTo: view.centerY, constant: Constant.centerInset),
            titleLabel.left.constraint(equalTo: view.left, constant: Constant.baseInset),
            titleLabel.right.constraint(equalTo: view.right, constant: -Constant.baseInset)
        ])
    }
}

// MARK: - IOnboardingView

extension OnboardingViewController: IOnboardingView { }
