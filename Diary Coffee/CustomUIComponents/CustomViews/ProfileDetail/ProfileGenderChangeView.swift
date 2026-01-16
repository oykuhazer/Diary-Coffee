//
//  ProfileGenderChangeView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 1.12.2024.
//

import UIKit

class ProfileGenderChangeView: UIView {

  
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("change_gender", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = AppColors.color2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var maleButton: UIButton = createGenderButton(withTitle: NSLocalizedString("male", comment: ""))
    private lazy var femaleButton: UIButton = createGenderButton(withTitle: NSLocalizedString("female", comment: ""))
    private lazy var otherButton: UIButton = createGenderButton(withTitle: NSLocalizedString("other", comment: ""))
    var onDismiss: (() -> Void)?
    
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
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.color26
        view.layer.cornerRadius = 16
        return view
    }()
    
    private var selectedButton: UIButton?

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = AppColors.color46

        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        otherButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(maleButton)
        containerView.addSubview(femaleButton)
        containerView.addSubview(otherButton)
        containerView.addSubview(doneButton)
        containerView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
          
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
         
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
          
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            maleButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            maleButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            maleButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            maleButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            femaleButton.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: 12),
            femaleButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            femaleButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            femaleButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            otherButton.topAnchor.constraint(equalTo: femaleButton.bottomAnchor, constant: 12),
            otherButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            otherButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            otherButton.heightAnchor.constraint(equalToConstant: 44),
            
           
            doneButton.topAnchor.constraint(equalTo: otherButton.bottomAnchor, constant: 20),
            doneButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 44),
        ])

      
        maleButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        otherButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func createGenderButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(AppColors.color2, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return button
    }
    
    func configure(selectedGender: String?) {
        switch selectedGender {
        case NSLocalizedString("male", comment: ""):
            genderButtonTapped(maleButton)
        case NSLocalizedString("female", comment: ""):
            genderButtonTapped(femaleButton)
        case NSLocalizedString("other", comment: ""):
            genderButtonTapped(otherButton)
        default:
            break
        }
    }

    @objc private func genderButtonTapped(_ sender: UIButton) {
      
        selectedButton?.backgroundColor = .clear
        selectedButton?.setTitleColor(AppColors.color2, for: .normal)
        
     
        sender.backgroundColor = AppColors.color4
        sender.setTitleColor(.white, for: .normal)
        selectedButton = sender
    }
    
    @objc private func doneButtonTapped() {
            guard let selectedGender = selectedButton?.title(for: .normal) else {
                
                return
            }

            UserProfile.shared.gender = selectedGender

        SaveUserProfileRequest.shared.saveUserProfile(in: self.superview ?? self) { result in
                switch result {
                case .success(_):
                    
                    self.removeFromSuperview()
                    self.onDismiss?()
                  
                case .failure(_):
                 
                    self.removeFromSuperview()
                   
                }
            }

        }

    
    @objc private func closeButtonTapped() {
        removeFromSuperview()
    }
}
