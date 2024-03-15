//
//  StatisticsCell.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 09.03.2024.
//

import UIKit

final class StatisticsCell: UITableViewCell {
    struct Model {
        let counter: Int
        let description: String
    }

    private enum Constant {
        static let counterLabelFontSize: CGFloat = 34
        static let descriptionLabelFontSize: CGFloat = 12
        static let baseCornerRadius: CGFloat = 16
        static let baseInset: CGFloat = 12
    }

    // MARK: - UI

    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.counterLabelFontSize, weight: .bold)

        return label.forAutolayout()
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.descriptionLabelFontSize)

        return label.forAutolayout()
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [counterLabel, descriptionLabel])
        stackView.axis = .vertical

        return stackView.forAutolayout()
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(
            by: .init(
                top: .zero,
                left: .zero,
                bottom: Constant.baseInset,
                right: .zero
            )
        )

        setGradientBorder()
    }

    // MARK: - Public

    func configure(with model: Model) {
        counterLabel.text = "\(model.counter)"
        descriptionLabel.text = model.description
    }

    // MARK: - Private

    private func setupUI() {
        textStackView
            .placedOn(contentView)
            .pin(to: contentView, inset: Constant.baseInset)
    }

    private func setGradientBorder() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [
            Assets.gradient3.color.cgColor,
            Assets.gradient2.color.cgColor,
            Assets.gradient1.color.cgColor
        ]

        gradientLayer.startPoint = .init(x: 0.0, y: 0.5)
        gradientLayer.endPoint = .init(x: 1.0, y: 0.5)

        let renderer = UIGraphicsImageRenderer(bounds: contentView.bounds)
        let color = renderer.image { gradientLayer.render(in: $0.cgContext) }
        let gradientColor = UIColor(patternImage: color)

        contentView.layer.borderColor = gradientColor.cgColor
        contentView.layer.cornerRadius = Constant.baseCornerRadius
        contentView.layer.borderWidth = 1
    }

}
