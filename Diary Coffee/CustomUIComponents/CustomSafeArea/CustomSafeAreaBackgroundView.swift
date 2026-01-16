//
//  CustomSafeAreaBackgroundView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 31.10.2024.
//

import UIKit

class CustomSafeAreaBackgroundView: UIView {
    
    init(backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupConstraints()
    }
}
