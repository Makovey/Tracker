//
//  EventsScheduleViewController.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 29.01.2024.
//

import UIKit

protocol IEventsScheduleView: AnyObject { }

final class EventsScheduleViewController: UIViewController {
    private enum Constant {
        static let baseInset: CGFloat = 16
        static let baseCornerRadius: CGFloat = 16
        static let cellsHeight: CGFloat = 75
    }
    
    // MARK: = Properties

    private let weekDays = WeekDay.allCases
    private let presenter: any IEventsSchedulePresenter
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = Constant.baseCornerRadius
        tableView.isScrollEnabled = false

        tableView.separatorColor = .red
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(
            top: .zero,
            left: Constant.baseInset,
            bottom: .zero,
            right: Constant.baseInset
        )

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeekDayCell.self, forCellReuseIdentifier: WeekDayCell.identifier)
        
        return tableView.forAutolayout()
    }()
    
    private lazy var doneButton: PrimaryButton = {
        let button = PrimaryButton(style: .enabled, text: "Готово") // TODO: Localization
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        return button.forAutolayout()
    }()

    // MARK: - Lifecycle

    init(presenter: some IEventsSchedulePresenter) {
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

        title = "Расписание" // TODO: Localization
        
        tableView.placedOn(view)
        NSLayoutConstraint.activate([
            tableView.top.constraint(equalTo: view.safeTop, constant: Constant.baseInset),
            tableView.left.constraint(equalTo: view.left, constant: Constant.baseInset),
            tableView.right.constraint(equalTo: view.right, constant: -Constant.baseInset),
            tableView.height.constraint(equalToConstant: Constant.cellsHeight * CGFloat(weekDays.count))
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
    private func doneButtonTapped() {
        presenter.doneButtonTapped()
    }
}

// MARK: - IEventsScheduleView

extension EventsScheduleViewController: IEventsScheduleView { }

// MARK: - UITableViewDataSource

extension EventsScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WeekDayCell.identifier,
            for: indexPath
        ) as? WeekDayCell else { return UITableViewCell() }
        
        if indexPath.row == weekDays.count - 1 {
            cell.separatorInset = .init(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        cell.delegate = self
        cell.selectionStyle = .none
        cell.configure(title: weekDays[indexPath.row].label)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.cellsHeight
    }
}

extension EventsScheduleViewController: IWeekDayCellDelegate {
    func dayChosen() {
        print(#function)
    }
}
