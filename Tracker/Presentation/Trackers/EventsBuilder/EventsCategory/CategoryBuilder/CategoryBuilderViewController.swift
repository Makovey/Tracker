//
//  CategoryBuilderViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 03.02.2024.
//

import UIKit

protocol ICategoryBuilderInput {
    func setExistedCategories(_ categories: [String])
}

protocol ICategoryBuilderView: AnyObject { }

final class CategoryBuilderViewController: UIViewController {
    private enum Constant {
        static let baseInset: CGFloat = 16
        static let baseCornerRadius: CGFloat = 16
        static let cellsHeight: CGFloat = 75
    }
    
    // MARK: - Properties
    
    private let presenter: any ICategoryBuilderPresenter
    
    private var existedCategories = [String]()
    private var categoryName: String? {
        didSet { checkAvailability() }
    }
    
    // MARK: - UI
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .primaryElementBackground
        textField.placeholder = "Введите название категории" // TODO: Localization
        textField.clearButtonMode = .whileEditing

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
        
        return textField.forAutolayout()
    }()
    
    private lazy var errorLabel: UILabel = { // TODO: make a component with errorLabel and textField
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .canceledState
        label.textAlignment = .center
        label.text = "Такая категория уже существует"
        
        return label.forAutolayout()
    }()
    
    private lazy var doneButton: PrimaryButton = {
        let button = PrimaryButton(style: .disabled, text: "Готово")
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle

    init(presenter: some ICategoryBuilderPresenter) {
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
        navigationItem.setHidesBackButton(true, animated: true)

        title = "Новая категория"
        errorLabel.isHidden = true
        
        textField.placedOn(view)
        NSLayoutConstraint.activate([
            textField.top.constraint(equalTo: view.safeTop, constant: 24),
            textField.left.constraint(equalTo: view.left, constant: Constant.baseInset),
            textField.right.constraint(equalTo: view.right, constant: -Constant.baseInset),
            textField.height.constraint(equalToConstant: Constant.cellsHeight)
        ])
        
        errorLabel.placedOn(view)
        NSLayoutConstraint.activate([
            errorLabel.top.constraint(equalTo: textField.bottom, constant: Constant.baseInset / 2),
            errorLabel.left.constraint(equalTo: textField.left),
            errorLabel.right.constraint(equalTo: textField.right),
        ])
        
        doneButton.placedOn(view)
        NSLayoutConstraint.activate([
            doneButton.left.constraint(equalTo: view.left, constant: 20),
            doneButton.right.constraint(equalTo: view.right, constant: -20),
            doneButton.bottom.constraint(equalTo: view.safeBottom, constant: -Constant.baseInset),
            doneButton.height.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func textFieldValueChanged(_ sender: UITextField) {
        categoryName = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @objc
    private func doneButtonTapped() {
        guard let categoryName else { return }
        
        guard existedCategories.first(where: { $0 == categoryName }) == nil else { // TODO: -> presenter
            errorLabel.isHidden = false
            return
        }
        
        presenter.doneButtonTapped(category: categoryName)
    }
    
    private func checkAvailability() {
        if categoryName?.isEmpty == false {
            UIView.animate(withDuration: 0.3) {
                self.doneButton.enable()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.doneButton.disable()
            }
        }
    }
}

// MARK: - ICategoryBuilderView

extension CategoryBuilderViewController: ICategoryBuilderView { }

// MARK: - ICategoryBuilderInput

extension CategoryBuilderViewController: ICategoryBuilderInput {
    func setExistedCategories(_ categories: [String]) {
        existedCategories = categories
    }
}