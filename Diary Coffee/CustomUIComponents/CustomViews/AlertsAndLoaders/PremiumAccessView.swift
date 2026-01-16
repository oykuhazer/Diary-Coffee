//
//  PremiumAccessView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 23.11.2024.
//

import UIKit

class PremiumAccessView: UIView {

   
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.color20
        view.layer.cornerRadius = 16
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 10
        return view
    }()

    private let premiumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "premiumaccess")
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowOffset = CGSize(width: 0, height: 5)
        imageView.layer.shadowRadius = 5
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("premium_access", comment: "")
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = AppColors.color2
        label.textAlignment = .center
        return label
    }()

    private let getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("get_started", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(AppColors.color2, for: .normal)
        button.backgroundColor = AppColors.color28
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(getStartedTapped), for: .touchUpInside)
        return button
    }()

    private let gradientLayer = CAGradientLayer()

  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = AppColors.color34
        addSubview(containerView)
        containerView.addSubview(premiumImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(getStartedButton)

        setupFeatures()
        setupConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient()
    }

    private func setupGradient() {
        gradientLayer.colors = [
            AppColors.color35.cgColor,
            AppColors.color36.cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = getStartedButton.bounds
        if gradientLayer.superlayer == nil {
            getStartedButton.layer.insertSublayer(gradientLayer, at: 0)
        }
    }

    private func setupFeatures() {
        
        let features = [
            NSLocalizedString("in_depth_analysis", comment: ""),
            NSLocalizedString("up_to_3_photos", comment: ""),
            NSLocalizedString("daily_entries", comment: ""),
            NSLocalizedString("express_your_mood", comment: ""),
            NSLocalizedString("special_gift_awaits", comment: "")
        ]

        var previousLabel: UILabel?

        for feature in features {
            let label = createFeatureLabel(title: feature)
            containerView.addSubview(label)

            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
            ])

            if let previous = previousLabel {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            }

            previousLabel = label
        }

        if let lastLabel = previousLabel {
            getStartedButton.topAnchor.constraint(equalTo: lastLabel.bottomAnchor, constant: 30).isActive = true
        }
    }

    private func createFeatureLabel(title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "• \(title)"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = AppColors.color2
        label.textAlignment = .center
        return label
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 500),

           
            premiumImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            premiumImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            premiumImageView.widthAnchor.constraint(equalToConstant: 170),
            premiumImageView.heightAnchor.constraint(equalToConstant: 170),

           
            titleLabel.topAnchor.constraint(equalTo: premiumImageView.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

           
            getStartedButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            getStartedButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            getStartedButton.heightAnchor.constraint(equalToConstant: 50),
            getStartedButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }

    @objc private func getStartedTapped() {
      
        self.removeFromSuperview() 
    }

}
