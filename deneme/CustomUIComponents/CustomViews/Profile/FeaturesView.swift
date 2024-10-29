//
//  FeaturesView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 23.10.2024.
//

import UIKit

class FeaturesView: UIView {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Features"
        label.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 20) // Kalın font ve boyut
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.92, green: 0.84, blue: 0.71, alpha: 1.0) // EAD5B5 rengi
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8 // Kare görünümü için kenarları çok hafif yuvarlatma
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "widget") // Asset dosyasındaki widget resmini kullanıyoruz
        imageView.tintColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0) // Yeşil renk
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Widgets"
        label.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Background and corner radius
        self.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 12
        
        // Add subviews
        addSubview(headerLabel) // Sol üst köşedeki Features yazısı
        addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(arrowImageView)
        
        // Setup constraints for the views
        NSLayoutConstraint.activate([
            // Header Label Constraints (Sol üst köşede)
            headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -40),
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            
            // Icon Container View Constraints
            iconContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            iconContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor), // Features yazısının altında olacak
            iconContainerView.widthAnchor.constraint(equalToConstant: 40), // Kare görünüm
            iconContainerView.heightAnchor.constraint(equalToConstant: 40), // Kare görünüm
            
            // Icon ImageView Constraints (Merkeze yerleştirilmiş)
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Title Label Constraints
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            
            // Arrow ImageView Constraints
            arrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
