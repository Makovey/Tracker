//
//  StatusView.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 09.03.2024.
//

import UIKit

final class StatusView: UIView {
    struct Model {
        let labelText: String
        let image: UIImage
    }

    private enum Constant {
        static let baseSize: CGSize = .init(width: 80, height: 80)
        static let baseSystemFont: CGFloat = 12
        static let baseSpacing: Int = 8
    }

    // MARK: - Properties

    private let model: Model

    // MARK: - UI

    private lazy var mainStack: UIStackView = {
        let imageView = UIImageView(image: model.image)
        imageView.frame = .init(
            x: .zero,
            y: .zero,
            width: Constant.baseSize.width,
            height: Constant.baseSize.height
        )

        let label = UILabel()
        label.text = model.labelText
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Constant.baseSystemFont)

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = .init(integerLiteral: Constant.baseSpacing)

        return stackView.forAutolayout()
    }()

    // MARK: - Lifecycle

    init(model: Model) {
        self.model = model

        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }

    override var intrinsicContentSize: CGSize {
        mainStack.frame.size
    }

    // MARK: - Public

    func update(with model: Model) {
        mainStack.arrangedSubviews.forEach {
            switch $0 {
            case let imageView as UIImageView:
                imageView.image = model.image
            case let label as UILabel:
                label.text = model.labelText
            default: break
            }
        }

        invalidateIntrinsicContentSize()
    }


    // MARK: - Private

    private func setupUI() {
        mainStack
            .placedOn(self)
            .pinToCenter(of: self)

        mainStack.layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
}
