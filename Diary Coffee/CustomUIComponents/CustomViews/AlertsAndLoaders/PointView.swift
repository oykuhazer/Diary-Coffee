//
//  PointView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 23.11.2024.
//

import UIKit

class PointView: UIView {

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.color20
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "a")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("enjoying_diary_coffee", comment: "")
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = AppColors.color2
        label.textAlignment = .center
        return label
    }()

    
    private let noButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("no", comment: ""), for: .normal)
        button.setTitleColor(AppColors.color2, for: .normal)
        button.backgroundColor = AppColors.color4
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("yes", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.color28
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        return button
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupView() {
        backgroundColor = AppColors.color31

        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(noButton)
        containerView.addSubview(yesButton)

        setupConstraints()
        setupActions()
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        noButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
          
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            
            noButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            noButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            noButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -10),
            noButton.heightAnchor.constraint(equalToConstant: 50),
            
         
            yesButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            yesButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 10),
            yesButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            yesButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        noButton.addTarget(self, action: #selector(didTapNoButton), for: .touchUpInside)
    }
    
    @objc private func didTapNoButton() {
        self.removeFromSuperview()
    }
}
