//
//  ReminderView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class ReminderView: UIView {
    
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "alarm.fill")
        imageView.tintColor = AppColors.color2
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    public let timeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("21:30", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(AppColors.color3, for: .normal)
        button.backgroundColor = AppColors.color4
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
   
    let reminderPickerView = ReminderTimePickerView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        reminderPickerView.onTimeSelected = { [weak self] selectedTime in
            self?.updateTimeButtonTitle(with: selectedTime)
            self?.reminderPickerView.isHidden = true 
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = AppColors.color20
        self.layer.cornerRadius = 10
        
        addSubview(iconImageView)
        addSubview(timeButton)
        
        reminderPickerView.translatesAutoresizingMaskIntoConstraints = false
        reminderPickerView.isHidden = true
        addSubview(reminderPickerView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            timeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            timeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timeButton.widthAnchor.constraint(equalToConstant: 80),
            timeButton.heightAnchor.constraint(equalToConstant: 40),
            
            reminderPickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            reminderPickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            reminderPickerView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 10),
            reminderPickerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        timeButton.addTarget(self, action: #selector(timeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func timeButtonTapped() {
        reminderPickerView.isHidden.toggle()
    }
    
    public func updateTimeButtonTitle(with date: Date) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let formattedTime = formatter.string(from: date)
        timeButton.setTitle(formattedTime, for: .normal)
    }
}
