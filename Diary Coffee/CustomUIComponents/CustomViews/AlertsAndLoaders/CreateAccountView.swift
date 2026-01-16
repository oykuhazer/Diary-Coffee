//
//  CreateAccountView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 23.11.2024.
//


import UIKit

class CreateAccountView: UIView {

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.color20
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("create_an_account", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = AppColors.color2
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("log_in_save_records", comment: "")
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = AppColors.color2
        label.numberOfLines = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "createaccount")
        return imageView
    }()
    
    private let laterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("later", comment: ""), for: .normal)
        button.setTitleColor(AppColors.color2, for: .normal)
        button.backgroundColor = AppColors.color4
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("create", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.color28
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: configuration), for: .normal)
        button.tintColor = AppColors.color32
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

  
    var dismiss: (() -> Void)?

  
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
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(imageView)
        containerView.addSubview(laterButton)
        containerView.addSubview(createButton)
        containerView.addSubview(closeButton)

        setupConstraints()
        setupActions()
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        laterButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 470),
            
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            
           
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
           
            imageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 220),
            imageView.heightAnchor.constraint(equalToConstant: 220),
            
           
            laterButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 35),
            laterButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            laterButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -10),
            laterButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            createButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 35),
            createButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 10),
            createButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        laterButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }

    @objc private func handleDismiss() {
        dismiss?() 
    }
}
