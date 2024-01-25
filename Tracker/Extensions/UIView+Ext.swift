//
//  UIView+Ext.swift
//  Tracker
//
//  Created by MAKOVEY Vladislav on 07.01.2024.
//

import UIKit

extension UIView {
    var top: NSLayoutYAxisAnchor { topAnchor }
    var bottom: NSLayoutYAxisAnchor { bottomAnchor }
    var left: NSLayoutXAxisAnchor { leadingAnchor }
    var right: NSLayoutXAxisAnchor { trailingAnchor }
    var height: NSLayoutDimension { heightAnchor }
    var width: NSLayoutDimension { widthAnchor }
    var centerY: NSLayoutYAxisAnchor { centerYAnchor }
    var centerX: NSLayoutXAxisAnchor { centerXAnchor }
    
    var safeTop: NSLayoutYAxisAnchor { safeAreaLayoutGuide.topAnchor }
    var safeBottom: NSLayoutYAxisAnchor { safeAreaLayoutGuide.bottomAnchor }
    var safeLeft: NSLayoutXAxisAnchor { safeAreaLayoutGuide.leadingAnchor }
    var safeRight: NSLayoutXAxisAnchor { safeAreaLayoutGuide.trailingAnchor }
    var safeHeight: NSLayoutDimension { safeAreaLayoutGuide.heightAnchor }
    var safeWidth: NSLayoutDimension { safeAreaLayoutGuide.widthAnchor }
}

extension UIView {
    func forAutolayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func placedOn(_ parent: UIView) -> Self {
        parent.addSubview(self.forAutolayout())
        return self
    }
    
    func pin(to parent: UIView, inset: CGFloat = .zero) {
        NSLayoutConstraint.activate([
            self.top.constraint(equalTo: parent.top, constant: inset),
            self.left.constraint(equalTo: parent.left, constant: inset),
            self.right.constraint(equalTo: parent.right, constant: -inset),
            self.bottom.constraint(equalTo: parent.bottom, constant: -inset)
        ])
    }
    
    func pinToCenter(of view: UIView) {
        NSLayoutConstraint.activate([
            self.centerX.constraint(equalTo: view.centerX),
            self.centerY.constraint(equalTo: view.centerY)
        ])
    }
}
