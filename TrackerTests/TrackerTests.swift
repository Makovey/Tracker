//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by MAKOVEY Vladislav on 13.03.2024.
//

import SnapshotTesting
import XCTest
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testLightInterfaceTabBar() throws {
        let vc = TabBarController()
        assertSnapshot(
            matching: vc,
            as: .image(
                traits: .init(
                    userInterfaceStyle: .light
                )
            )
        )
    }

    func testDarkInterfaceTabBar() throws {
        let vc = TabBarController()
        assertSnapshot(
            matching: vc,
            as: .image(
                traits: .init(
                    userInterfaceStyle: .dark
                )
            )
        )
    }
}
