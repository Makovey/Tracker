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
    
    // MARK: - Properties

    private let weekDays = WeekDay.allCases
    private let presenter: any IEventsSchedulePresenter
    private var selectedDays =  Set<WeekDay>()
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = Constant.baseCornerRadius
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeekDayCell.self, forCellReuseIdentifier: WeekDayCell.identifier)
        
        return tableView.forAutolayout()
    }()
    
    private lazy var doneButton: PrimaryButton = {
        let button = PrimaryButton(style: .enabled, text: "common.doneButton.title".localized)
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

        title = "common.schedule.title".localized
        
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
        presenter.doneButtonTapped(selectedDays: selectedDays)
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
        let cell: WeekDayCell = tableView.dequeueCell(for: indexPath)

        let weekDay = weekDays[indexPath.row]
        let isDaySelected = selectedDays.first(where: { $0 == weekDay })
        
        cell.delegate = self
        cell.selectionStyle = .none
        cell.configure(
            weekDay: weekDay,
            isDayAlreadySelected: isDaySelected != nil,
            isLastCell: indexPath.row == weekDays.count - 1
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.cellsHeight
    }
}

// MARK: - IWeekDayCellDelegate

extension EventsScheduleViewController: IWeekDayCellDelegate {
    func dayChosen(isOn: Bool, day: WeekDay) {
        if isOn { selectedDays.insert(day) }
        else { selectedDays.remove(day) }
    }
}

// MARK: - IEventsScheduleInput

extension EventsScheduleViewController: IEventsScheduleInput {
    func setSelectedDays(selectedDays: Set<WeekDay>) {
        self.selectedDays = selectedDays
    }
}
