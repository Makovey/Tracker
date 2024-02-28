//
//  OnboardingManagerViewController.swift
//
//  in: Tracker
//  by: MAKOVEY Vladislav
//  on: 25.02.2024
//

import UIKit

protocol IOnboardingManagerView: AnyObject { }

final class OnboardingManagerViewController: UIPageViewController {
    private enum Constant {
        static let baseInset: CGFloat = 20
        static let buttonHeight: CGFloat = 60
    }

    // MARK: - Properties

    private let presenter: any IOnboardingManagerPresenter
    private let onboardings: [UIViewController]

    // MARK: - UI

    private lazy var primaryButton: PrimaryButton = {
        let button = PrimaryButton(style: .enabledStatic, text: "onboarding.primaryButton.title".localized)
        button.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        return button.forAutolayout()
    }()

    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = onboardings.count

        control.currentPageIndicatorTintColor = .staticBlack
        control.pageIndicatorTintColor = .staticBlack.withAlphaComponent(0.3)
        control.isUserInteractionEnabled = false

        return control.forAutolayout()
    }()

    // MARK: - Lifecycle

    init(
        presenter: some IOnboardingManagerPresenter,
        onboardings: [UIViewController]
    ) {
        self.presenter = presenter
        self.onboardings = onboardings
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) { nil }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialState()
        setupUI()
    }

    // MARK: - Private

    private func setupUI() {
        primaryButton.placedOn(view)
        NSLayoutConstraint.activate([
            primaryButton.left.constraint(equalTo: view.left, constant: Constant.baseInset),
            primaryButton.right.constraint(equalTo: view.right, constant: -Constant.baseInset),
            primaryButton.bottom.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            primaryButton.height.constraint(equalToConstant: Constant.buttonHeight)
        ])

        pageControl.placedOn(view)
        NSLayoutConstraint.activate([
            pageControl.centerX.constraint(equalTo: view.centerX),
            pageControl.bottom.constraint(equalTo: primaryButton.top, constant: -24)
        ])
    }

    private func setupInitialState() {
        self.dataSource = self
        self.delegate = self
        guard let onboarding = onboardings.first else { return }
        setViewControllers([onboarding], direction: .forward, animated: true)
    }

    @objc
    private func primaryButtonTapped() {
        presenter.primaryButtonTapped()
    }
}

// MARK: - IOnboardingManagerView

extension OnboardingManagerViewController: IOnboardingManagerView { }

// MARK: - UIPageViewControllerDelegate

extension OnboardingManagerViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let currentController = pageViewController.viewControllers?.first,
              let currentIndex = onboardings.firstIndex(of: currentController)
        else { return }

        pageControl.currentPage = currentIndex
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingManagerViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = onboardings.firstIndex(of: viewController), currentIndex - 1 >= 0 else {
            return nil
        }

        return onboardings[currentIndex - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = onboardings.firstIndex(of: viewController),
                currentIndex + 1 < onboardings.count else {
            return nil
        }

        return onboardings[currentIndex + 1]
    }
}
