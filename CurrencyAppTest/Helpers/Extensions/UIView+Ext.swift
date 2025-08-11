//
//  UIView+Ext.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 31.07.2025.
//

import UIKit

extension UIView {
    func fillView(with subview: UIView,
                  edgeInsets: EdgeInsets = EdgeInsets()) {
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(
                equalTo: topAnchor,
                constant: edgeInsets.vertical.top),
            subview.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: edgeInsets.vertical.bottom),
            subview.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: edgeInsets.horizontal.left),
            subview.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: edgeInsets.horizontal.right)
        ])
    }
    
    func fillSafeArea(with subview: UIView,
                      edgeInsets: EdgeInsets = EdgeInsets()) {
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: edgeInsets.vertical.top),
            subview.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: edgeInsets.vertical.bottom),
            subview.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: edgeInsets.horizontal.left),
            subview.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: edgeInsets.horizontal.right)
        ])
    }
    
    func attachOnTopSafeArea(subview: UIView,
                     edgeInsets: EdgeInsets = EdgeInsets()) {
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: edgeInsets.vertical.top),

            subview.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: edgeInsets.horizontal.left),
            subview.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: edgeInsets.horizontal.right)
        ])
    }
    
    func center(subview: UIView,
                offset: XYOffset = XYOffset()) {
        
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(
                equalTo: centerXAnchor,
                constant: offset.x),
            subview.centerYAnchor.constraint(
                equalTo: centerYAnchor,
                constant: offset.y)
        ])
    }
    
    func setSize(width: CGFloat? = nil, height: CGFloat? = nil) {
        if let width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
