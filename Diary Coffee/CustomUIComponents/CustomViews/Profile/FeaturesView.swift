//
//  FeaturesView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 23.10.2024.
//

protocol FeaturesViewDelegate: AnyObject {
    func didTapFeaturesView()
}

import UIKit

class FeaturesView: UIView {
    
    weak var delegate: FeaturesViewDelegate?
    

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("features", comment: "")
        label.textColor = AppColors.color5
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.color75
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "widget")
        imageView.tintColor = AppColors.color76
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("themes", comment: "")
        label.textColor = AppColors.color5
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = AppColors.color5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupTapGesture()
    }
    
    private func setupView() {
        self.backgroundColor = AppColors.color1
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 12
        
        addSubview(headerLabel)
        addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -40),
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            
            iconContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            iconContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 40),
            iconContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(featuresViewTapped))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    @objc private func featuresViewTapped() {
        delegate?.didTapFeaturesView()
    }
}
