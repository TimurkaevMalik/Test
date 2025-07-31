//
//  BlurLoaderView.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 29.07.2025.
//

import UIKit

final class BlurLoaderView: UIView {
    
    private let visualEffectView = {
        let effect = UIVisualEffectView()
        effect.translatesAutoresizingMaskIntoConstraints = false
        return effect
    }()
    
    private let activityIndicator = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(with blurStyle: UIBlurEffect.Style) {
        super.init(frame: .zero)
        let blurEffect = UIBlurEffect(style: blurStyle)
        visualEffectView.effect = blurEffect
        
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoader() {
        isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
        }
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 1
        }, completion: { _ in
            self.isHidden = true
            self.activityIndicator.stopAnimating()
        })
    }
}

private extension BlurLoaderView {
    func setupUI() {
        addSubview(visualEffectView)
        addSubview(activityIndicator)
        activityIndicator.backgroundColor = .white
        activityIndicator.layer.masksToBounds = true
        activityIndicator.layer.cornerRadius = 8
        
        activityIndicator.setSize(width: 80, height: 80)
        center(subview: activityIndicator)
        fillView(with: visualEffectView)
    }
}
