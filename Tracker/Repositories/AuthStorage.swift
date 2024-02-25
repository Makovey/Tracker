//
//  AuthStorage.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 25.02.2024.
//

import Foundation

protocol IAuthStorage {
    var isAlreadyAuthenticated: Bool { get set }
}

struct AuthStorage: IAuthStorage {
    private struct Constant {
        static let authKey = "auth"
    }

    // MARK: - Properties

    private let userDefaults = UserDefaults.standard

    var isAlreadyAuthenticated: Bool {
        get { userDefaults.bool(forKey: Constant.authKey) }
        set { userDefaults.setValue(newValue, forKey: Constant.authKey) }
    }
}
