//
//  IndicatorView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 5.12.2024.
//

import UIKit

class IndicatorView: UIView {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var indicatorColor: UIColor? {
        didSet {
            activityIndicator.color = indicatorColor
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.clear 
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        isHidden = true
    }
    
    func show() {
        activityIndicator.startAnimating()
        isHidden = false
    }
    
    func hide() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}
