//
//  PrimaryButton.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 23.01.2024.
//

import Foundation
import UIKit

final class PrimaryButton: UIButton {
    private enum Constant {
        static let cornerRadius: CGFloat = 16
        static let baseFont: CGFloat = 16
    }
    
    // MARK: - Properties
    
    private let text: String
    private let style: Style
    
    // MARK: - Lifecycle
    
    init(style: Style, text: String) {
        self.text = text
        self.style = style
        
        super.init(frame: .zero)
        
        setupUI()
        setupInitialState()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public
    
    func enable() {
        self.isEnabled = true
        backgroundColor = Assets.enabledState.color
        setTitleColor(.systemBackground, for: .normal)
    }
    
    func disable() {
        self.isEnabled = false
        backgroundColor = Assets.primaryGray.color
        setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        layer.cornerRadius = Constant.cornerRadius
        layer.masksToBounds = true
        
        titleLabel?.font = .systemFont(ofSize: Constant.baseFont)
        
        switch style {
        case .enabled:
            enable()
        case .disabled:
            disable()
        case .canceled:
            layer.borderWidth = 1.0
            layer.borderColor = Assets.canceledState.color.cgColor

            backgroundColor = .systemBackground
            setTitleColor(Assets.canceledState.color, for: .normal)
        case .option:
            backgroundColor = Assets.optionState.color
        case .enabledStatic:
            backgroundColor = Assets.staticBlack.color
        }
    }
    
    private func setupInitialState() {
        setTitle(text, for: .normal)
    }
}

extension PrimaryButton {
    enum Style {
        case enabled
        case disabled
        case canceled
        case option
        case enabledStatic
    }
}

