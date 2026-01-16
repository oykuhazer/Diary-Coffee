//
//  ProfileBirthdayChangeView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 1.12.2024.
//

import UIKit

class ProfileBirthdayChangeView: UIView {

  
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("change_birthday", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = AppColors.color2
        label.textAlignment = .center
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.overrideUserInterfaceStyle = .light
        picker.tintColor = AppColors.color2
        picker.setValue(AppColors.color2, forKey: "textColor")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        picker.minimumDate = dateFormatter.date(from: "1950/01/01")
        picker.maximumDate = dateFormatter.date(from: "2017/12/31")
        
        return picker
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        button.setTitleColor(AppColors.color2, for: .normal)
        button.backgroundColor = AppColors.color4
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("yes", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.color77
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        
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
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setupView() {
        backgroundColor = AppColors.color78
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(datePicker)
        containerView.addSubview(cancelButton)
        containerView.addSubview(okButton)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)

        setupConstraints()
    }
    
   
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            datePicker.heightAnchor.constraint(equalToConstant: 150),
            
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5, constant: -24),
            
            okButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            okButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            okButton.heightAnchor.constraint(equalToConstant: 44),
            okButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5, constant: -24)
        ])
    }
    
    
    func configure(with birthDate: Date?) {
        if let birthDate = birthDate {
            datePicker.date = birthDate
        } else {
            datePicker.date = datePicker.maximumDate ?? Date()
        }
    }
    
    @objc private func okButtonTapped() {
          
          let selectedDate = datePicker.date
          UserProfile.shared.birthDate = selectedDate

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


    @objc private func cancelButtonTapped() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}


