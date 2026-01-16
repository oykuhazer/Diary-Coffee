//
//  MainAlertView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 19.11.2024.
//

import UIKit

class MainAlertView: UIView {
    
   
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.color20
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = AppColors.color2
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = AppColors.color2
        label.numberOfLines = 0
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        button.setTitleColor(AppColors.color2, for: .normal)
        button.backgroundColor = AppColors.color4
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("exit", comment: ""), for: .normal)
        button.setTitleColor(AppColors.color2, for: .normal)
        button.backgroundColor = AppColors.color3
        button.layer.cornerRadius = 8
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
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(cancelButton)
        containerView.addSubview(actionButton)
        
       
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
         
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
          
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
          
            cancelButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -8),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            
           
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            actionButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 8),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    func configure(
        title: String,
        message: String? = nil,
        cancelAction: @escaping () -> Void,
        actionButtonTitle: String = NSLocalizedString("delete", comment: ""),
        actionHandler: @escaping () -> Void
    ) {
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.isHidden = (message == nil)
        
       
      cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        
      
        actionButton.setTitle(actionButtonTitle, for: .normal)
        cancelButton.addAction(UIAction(handler: { _ in
            cancelAction()
        }), for: .touchUpInside)
        
        actionButton.addAction(UIAction(handler: { _ in
            actionHandler()
        }), for: .touchUpInside)
    }

}
