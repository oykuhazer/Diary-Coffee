//
//  ProblemView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 25.11.2024.
//

import UIKit

class ProblemView: UIView {

    enum ProblemState {
           case defaultState
           case maintenance
       }

       var state: ProblemState = .defaultState {
           didSet {
               updateForState()
           }
       }

    
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
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "problem")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("something_went_wrong", comment: "") + " 😉"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = AppColors.color2
        label.textAlignment = .center
        return label
    }()
    
    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("ok", comment: ""), for: .normal)
        button.backgroundColor = AppColors.color2
        button.setTitleColor(AppColors.color3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()

    private var titleLabelTopConstraint: NSLayoutConstraint?
    
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
        containerView.addSubview(okButton)

        setupConstraints()
      
        okButton.addTarget(self, action: #selector(didTapOkButton), for: .touchUpInside)
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
           
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 260),
            
          
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            
            okButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            okButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            okButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            okButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15)
                titleLabelTopConstraint?.isActive = true

                NSLayoutConstraint.activate([
                    titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                    titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
                ])
    }

    private func updateForState() {
           switch state {
           case .defaultState:
               titleLabel.text = NSLocalizedString("something_went_wrong", comment: "") + " 😉"
               titleLabelTopConstraint?.constant = 25
               okButton.isHidden = false
           case .maintenance:
               titleLabel.text = NSLocalizedString("services_maintenance", comment: "")
               titleLabelTopConstraint?.constant = 15
               okButton.isHidden = false
           }
       }

       @objc private func didTapOkButton() {
           if state == .defaultState {
               self.removeFromSuperview()
           }
          
       }
}
