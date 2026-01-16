//
//  LoginTitleView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 3.11.2024.
//

import UIKit

class LoginTitleView: UIView {
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        backgroundColor = AppColors.color3
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = NSLocalizedString("capture_every_sip", comment: "")
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        titleLabel.textColor = AppColors.color2
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 5)
        titleLabel.layer.shadowRadius = 8
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
