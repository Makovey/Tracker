//
//  WeekDayCell.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 29.01.2024.
//

import Foundation
import UIKit

protocol IWeekDayCellDelegate: AnyObject {
    func dayChosen()
}

final class WeekDayCell: UITableViewCell {
    private enum Constant {
        static let baseInset: CGFloat = 16
        static let baseFontSize: CGFloat = 17
    }

    weak var delegate: IWeekDayCellDelegate?
    static let identifier = "WeekDayCell"
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.baseFontSize)
        label.textColor = .label
        
        return label.forAutolayout()
    }()
    
    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .optionState
        switcher.addTarget(self, action: #selector(switcherValueChanged), for: .valueChanged)
        
        return switcher.forAutolayout()
    }()

    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Private
    
    private func setupUI() {
        backgroundColor = .primaryElementBackground

        titleLabel.placedOn(contentView)
        NSLayoutConstraint.activate([
            titleLabel.centerY.constraint(equalTo: contentView.centerY),
            titleLabel.left.constraint(equalTo: contentView.left, constant: Constant.baseInset)
        ])
        
        switcher.placedOn(contentView)
        NSLayoutConstraint.activate([
            switcher.centerY.constraint(equalTo: contentView.centerY),
            switcher.right.constraint(equalTo: contentView.right, constant: -Constant.baseInset)
        ])
    }
    
    @objc
    private func switcherValueChanged(switch: UISwitch) {
        delegate?.dayChosen()
    }
}
