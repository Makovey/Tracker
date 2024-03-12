//
//  AnalyticsManager.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 08.03.2024.
//

import YandexMobileMetrica

protocol IAnalyticsManager {
    func sendEvent(_ name: EventName)
    func sendTapEvent(_ name: TapEvent)
}

struct AnalyticsManager: IAnalyticsManager {
    private enum Constant {
        static let event = "event"
        static let screen = "screen"
        static let item = "item"
    }

    static func register() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: Secrets.apiKey) else {
            assertionFailure("Can't configure analytics manager with api key \(Secrets.apiKey)")
            return
        }

        YMMYandexMetrica.activate(with: configuration)
    }

    func sendEvent(_ name: EventName) {
        YMMYandexMetrica.reportEvent(
            Constant.event,
            parameters: [
                Constant.event: name.rawValue,
                Constant.screen: ScreenName.Main.rawValue
            ]
        )
    }
    
    func sendTapEvent(_ name: TapEvent) {
        YMMYandexMetrica.reportEvent(
            Constant.event,
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
