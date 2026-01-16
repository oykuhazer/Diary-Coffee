//
//  DisconnectView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 25.11.2024.
//

import UIKit

class DisconnectView: UIView {

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
        imageView.image = UIImage(named: "disconnect") 
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("failed_to_connect", comment: "")
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = AppColors.color2
        label.textAlignment = .center
        return label
    }()
    
     var disconnectButton: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle(NSLocalizedString("try_again", comment: ""), for: .normal)
         button.backgroundColor = AppColors.color2
         button.setTitleColor(AppColors.color3, for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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
        containerView.addSubview(disconnectButton)

        setupConstraints()
      
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        disconnectButton.translatesAutoresizingMaskIntoConstraints = false

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
         
            disconnectButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            disconnectButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            disconnectButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            disconnectButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

  
    @objc private func didTapNoButton() {
        self.removeFromSuperview()
    }
}
