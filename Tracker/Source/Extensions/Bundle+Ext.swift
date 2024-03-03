//
//  Bundle+Ext.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 03.03.2024.
//

import Foundation

private extension String {
    static let bundleName = "Tracker.bundle"
}

extension Bundle {
    static let current: Bundle = {
        let url = Bundle(for: BundleHandle.self).bundleURL.appendingPathComponent(.bundleName)
        guard let bundle = Bundle(url: url) else { fatalError("Bundle not found!") }

        return bundle
    }()
}

private class BundleHandle { }
