//
//  AnalyticsManager.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 08.03.2024.
//

import AppMetricaCore

protocol IAnalyticsManager {
    func sendEvent(_ name: EventName)
    func sendTapEvent(_ name: TapEvent)
}

struct AnalyticsManager: IAnalyticsManager {
    enum Constant {
        static let event = "event"
        static let screen = "screen"
        static let item = "item"
    }

    func sendEvent(_ name: EventName) {
        AppMetrica.reportEvent(
            name: Constant.event,
            parameters: [
                Constant.event: name.rawValue,
                Constant.screen: ScreenName.Main.rawValue
            ]
        )
    }
    
    func sendTapEvent(_ name: TapEvent) {
        AppMetrica.reportEvent(
            name: Constant.event,
            parameters: [
                Constant.event: EventName.click.rawValue,
                Constant.screen: ScreenName.Main.rawValue,
                Constant.item: name.rawValue
            ]
        )
    }
}

enum EventName: String { case open, close, click }
enum ScreenName: String { case Main }
enum TapEvent: String { case addTrack, track, filter, edit, delete }
