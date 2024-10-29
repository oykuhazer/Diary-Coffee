//
//  PremiumView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 23.10.2024.
//

import UIKit

class PremiumView: UIView {
    
    private let crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "crown") // Asset dosyasındaki "crown" resmini kullan
        imageView.tintColor = UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let prizeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "prize") // Asset dosyasındaki "prize" resmini kullan
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Elevate coffee moments"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0)
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Upgrade for the ultimate experience!"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0)
        label.textAlignment = .left
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        
        // Kalın ok simgesi için SymbolConfiguration
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: config)
        
        imageView.tintColor = UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0)
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
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 16
        self.backgroundColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        // Add subviews
        addSubview(crownImageView)
        addSubview(prizeImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(arrowImageView)
        
        // Layout constraints
        crownImageView.translatesAutoresizingMaskIntoConstraints = false
        prizeImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Büyütülmüş crownImageView (sol üstte olacak şekilde)
        NSLayoutConstraint.activate([
            crownImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            crownImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            crownImageView.widthAnchor.constraint(equalToConstant: 70),
            crownImageView.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        // Constraints for prizeImageView (sağda olacak şekilde ve büyük)
        NSLayoutConstraint.activate([
            prizeImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            prizeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),
            prizeImageView.widthAnchor.constraint(equalToConstant: 80), // Genişlik büyütüldü
            prizeImageView.heightAnchor.constraint(equalToConstant: 80), // Yükseklik büyütüldü
        ])
        
        // Constraints for titleLabel (crownImageView'in hemen altında)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: crownImageView.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: crownImageView.bottomAnchor, constant: -10),
        ])
        
        // Constraints for arrowImageView (titleLabel'in hemen sağında)
        NSLayoutConstraint.activate([
            arrowImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5),
            arrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor,constant: 0.5),
            arrowImageView.widthAnchor.constraint(equalToConstant: 15),
            arrowImageView.heightAnchor.constraint(equalToConstant: 15),
        ])
        
        // Constraints for descriptionLabel (titleLabel'in altında)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
        ])
    }
}
