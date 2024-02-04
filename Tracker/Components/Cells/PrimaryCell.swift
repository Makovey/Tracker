//
//  PrimaryCell.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 27.01.2024.
//

import Foundation
import UIKit

final class PrimaryCell: UITableViewCell {
    enum Accessory {
        case chevron, checkmark
    }

    private enum Constant {
        static let baseInset: CGFloat = 16
        static let baseFontSize: CGFloat = 17
    }
    
    static let identifier = "PrimaryCell"
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.baseFontSize)
        label.textColor = .label
        
        return label.forAutolayout()
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.baseFontSize)
        label.textColor = .primaryGray
        
        return label.forAutolayout()
    }()
    
    private lazy var accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .primaryGray
        imageView.contentMode = .scaleAspectFit
        
        return imageView.forAutolayout()
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        
        return stackView.forAutolayout()
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public
    
    func configure(
        title: String,
        subTitle: String? = nil,
        accessory: Accessory
    ) {
        if let subTitle {
            setupWithSubtitle(title: title, subTitle: subTitle)
        } else {
            setupWithTitle(title: title)
        }
        
        switch accessory {
        case .chevron:
            accessoryImageView.image = .chevron
        case .checkmark:
            accessoryImageView.isHidden = true
            accessoryImageView.image = UIImage(systemName: "checkmark")
            accessoryImageView.tintColor = .optionState
        }
    }
    
    func didSelect() {
        accessoryImageView.isHidden = false
    }
    
    func didDeselect() {
        accessoryImageView.isHidden = true
    }
    
    // MARK: - Private
    
    private func setupUI() {
        backgroundColor = .primaryElementBackground
        
        accessoryImageView.placedOn(contentView)
        NSLayoutConstraint.activate([
            accessoryImageView.centerY.constraint(equalTo: contentView.centerY),
            accessoryImageView.right.constraint(equalTo: contentView.right, constant: -Constant.baseInset),
            accessoryImageView.width.constraint(equalToConstant: 24),
            accessoryImageView.height.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupWithTitle(title: String) {
        titleLabel.text = title
        
        titleLabel.placedOn(contentView)
        NSLayoutConstraint.activate([
            titleLabel.centerY.constraint(equalTo: contentView.centerY),
            titleLabel.left.constraint(equalTo: contentView.left, constant: Constant.baseInset),
            titleLabel.right.constraint(equalTo: accessoryImageView.left, constant: -1)
        ])
    }
    
    private func setupWithSubtitle(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
        stackView.placedOn(contentView)
        NSLayoutConstraint.activate([
            stackView.top.constraint(equalTo: contentView.top, constant: 14),
            stackView.left.constraint(equalTo: contentView.left, constant: Constant.baseInset),
            stackView.right.constraint(equalTo: accessoryImageView.left, constant: -1),
            stackView.bottom.constraint(equalTo: contentView.bottom, constant: -14),
        ])
    }
}
