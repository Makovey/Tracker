//
//  EventsScheduleIO.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 06.02.2024.
//

import Foundation

protocol IEventsScheduleInput {
    func setSelectedDays(selectedDays: Set<WeekDay>)
}

protocol IEventsScheduleOutput: AnyObject {
    func scheduleSelected(_ schedule: Set<WeekDay>)
}
