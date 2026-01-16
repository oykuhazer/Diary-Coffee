//
//  RecordActionView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 19.11.2024.
//

import UIKit

class RequiredActionView: UIView {
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = AppColors.color2
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .justified
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = AppColors.color3
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10
        
       
        addSubview(contentView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            
            
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
          
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
   
    func configure(icon: UIImage?, message: String) {
        
        if let icon = icon {
          
            iconImageView.image = icon
            iconImageView.isHidden = false
            messageLabel.textAlignment = .justified
            
          
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20).isActive = true
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        } else {
            
            iconImageView.isHidden = true
            messageLabel.textAlignment = .justified
            
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        }
        
        messageLabel.text = message
        layoutIfNeeded()
    }
}
