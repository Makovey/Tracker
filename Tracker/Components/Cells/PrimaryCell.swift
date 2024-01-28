//
//  PrimaryCell.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 27.01.2024.
//

import Foundation
import UIKit

final class PrimaryCell: UITableViewCell {
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
    
    private lazy var chevron: UIImageView = {
        let imageView = UIImageView(image: .chevron)
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
    
    func configure(title: String, subTitle: String? = nil) {
        if let subTitle {
            setupWithSubtitle(title: title, subTitle: subTitle)
        } else {
            setupWithTitle(title: title)
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        backgroundColor = .primaryElementBackground
        
        chevron.placedOn(contentView)
        NSLayoutConstraint.activate([
            chevron.centerY.constraint(equalTo: contentView.centerY),
            chevron.right.constraint(equalTo: contentView.right, constant: -Constant.baseInset),
            chevron.width.constraint(equalToConstant: 24),
            chevron.height.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupWithTitle(title: String) {
        titleLabel.text = title
        
        titleLabel.placedOn(contentView)
        NSLayoutConstraint.activate([
            titleLabel.centerY.constraint(equalTo: contentView.centerY),
            titleLabel.left.constraint(equalTo: contentView.left, constant: Constant.baseInset),
            titleLabel.right.constraint(equalTo: chevron.left, constant: -1)
        ])
    }
    
    private func setupWithSubtitle(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
        stackView.placedOn(contentView)
        NSLayoutConstraint.activate([
            stackView.top.constraint(equalTo: contentView.top, constant: 14),
            stackView.left.constraint(equalTo: contentView.left, constant: Constant.baseInset),
            stackView.right.constraint(equalTo: chevron.left, constant: -1),
            stackView.bottom.constraint(equalTo: contentView.bottom, constant: -14),
        ])
    }
}
