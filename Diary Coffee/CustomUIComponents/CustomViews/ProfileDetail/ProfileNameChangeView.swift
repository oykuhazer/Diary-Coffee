//
//  ProfileNameChangeView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 1.12.2024.
//

import UIKit

class ProfileNameChangeView: UIView {

 
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("change_name", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = AppColors.color2
        label.textAlignment = .center
        return label
    }()
    
    private let nameTextFieldView: NameTextFieldView = {
        let view = NameTextFieldView()
        
        return view
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("done", comment: ""), for: .normal)
        button.backgroundColor = AppColors.color2
        button.setTitleColor(AppColors.color3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark.circle.fill")
        let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        button.setImage(image?.withConfiguration(configuration), for: .normal)
        button.tintColor = AppColors.color4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.color26
        view.layer.cornerRadius = 16
        return view
    }()
    
    var onDismiss: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupInitialName()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupInitialName()
    }
    
    private func setupUI() {
        backgroundColor = AppColors.color46

        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(nameTextFieldView)
        containerView.addSubview(doneButton)
        containerView.addSubview(closeButton)
        
       
        NSLayoutConstraint.activate([
           
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 230),
            
           
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
        
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            
            nameTextFieldView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            nameTextFieldView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameTextFieldView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            nameTextFieldView.heightAnchor.constraint(equalToConstant: 50),
            
           
            doneButton.topAnchor.constraint(equalTo: nameTextFieldView.bottomAnchor, constant: 25),
            doneButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 44),
        ])

        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        nameTextFieldView.textField.delegate = self
        
         self.nameTextFieldView.textField.becomeFirstResponder()
   
    }

    private func setupInitialName() {
        nameTextFieldView.textField.text = UserProfile.shared.name ?? ""
    }

    @objc private func doneButtonTapped() {
            
            if let newName = nameTextFieldView.textField.text, !newName.isEmpty {
                UserProfile.shared.name = newName
                
                
                SaveUserProfileRequest.shared.saveUserProfile(in: self.superview ?? self) { [weak self] result in
                    switch result {
                    case .success:
                      
                        self!.removeFromSuperview()
                        self!.onDismiss?()
                      
                    case .failure(let error):
                     
                        self!.removeFromSuperview()
                        
                    }
                }
          
        }
    }
    @objc private func closeButtonTapped() {
        removeFromSuperview()
    }
    
    
}


extension ProfileNameChangeView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text as NSString? else { return true }
        let newString = text.replacingCharacters(in: range, with: string).uppercased()
        
        
        if newString.count > 10 {
            return false
        }
        
        textField.text = newString
        return false
    }
}

