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
        imageView.image = UIImage(named: "crown")
        imageView.tintColor = AppColors.color51
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let prizeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "prize")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("elevate_coffee_moments", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = AppColors.color51
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("upgrade_ultimate_experience", comment: "")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = AppColors.color51
        label.textAlignment = .left
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        
       
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: config)
        
        imageView.tintColor = AppColors.color51
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
        self.backgroundColor = AppColors.color2
        
        addSubview(crownImageView)
        addSubview(prizeImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(arrowImageView)
        
    
        crownImageView.translatesAutoresizingMaskIntoConstraints = false
        prizeImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
       
        NSLayoutConstraint.activate([
            crownImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            crownImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            crownImageView.widthAnchor.constraint(equalToConstant: 70),
            crownImageView.heightAnchor.constraint(equalToConstant: 70),
        ])
        
      
        NSLayoutConstraint.activate([
            prizeImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            prizeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),
            prizeImageView.widthAnchor.constraint(equalToConstant: 80),
            prizeImageView.heightAnchor.constraint(equalToConstant: 80),
        ])
        
      
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: crownImageView.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: crownImageView.bottomAnchor, constant: -10),
        ])
        
        
        NSLayoutConstraint.activate([
            arrowImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5),
            arrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor,constant: 0.5),
            arrowImageView.widthAnchor.constraint(equalToConstant: 15),
            arrowImageView.heightAnchor.constraint(equalToConstant: 15),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
        ])
    }
}




