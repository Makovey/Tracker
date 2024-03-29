//
//  WeekDayCell.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 29.01.2024.
//

import Foundation
import UIKit

protocol IWeekDayCellDelegate: AnyObject {
    func dayChosen(isOn: Bool, day: WeekDay)
}

final class WeekDayCell: UITableViewCell {
    private enum Constant {
        static let baseInset: CGFloat = 16
        static let baseSwitcherRadius: CGFloat = 16
        static let baseFontSize: CGFloat = 17
    }

    weak var delegate: IWeekDayCellDelegate?
    private var weekDay: WeekDay?
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.baseFontSize)
        label.textColor = .label
        
        return label.forAutolayout()
    }()
    
    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = Assets.optionState.color
        switcher.backgroundColor = Assets.primaryLightGray.color
        switcher.addTarget(self, action: #selector(switcherValueChanged), for: .valueChanged)
        switcher.layer.cornerRadius = Constant.baseSwitcherRadius

        return switcher.forAutolayout()
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = Assets.transparent.color

        return view.forAutolayout()
    }()

    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public
    
    func configure(
        weekDay: WeekDay,
        isDayAlreadySelected: Bool,
        isLastCell: Bool
    ) {
        self.weekDay = weekDay
        
        titleLabel.text = self.weekDay?.label
        switcher.isOn = isDayAlreadySelected
        if isLastCell { separator.isHidden = true }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        backgroundColor = Assets.primaryElementBackground.color

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
        
        separator.placedOn(contentView)
        NSLayoutConstraint.activate([
            separator.left.constraint(equalTo: contentView.left, constant: Constant.baseInset),
            separator.right.constraint(equalTo: contentView.right, constant: -Constant.baseInset),
            separator.bottom.constraint(equalTo: contentView.bottom),
            separator.height.constraint(equalToConstant: 1)
        ])
    }
    
    @objc
    private func switcherValueChanged(switch: UISwitch) {
        guard let weekDay else { return }
        delegate?.dayChosen(isOn: switcher.isOn, day: weekDay)
    }
}
