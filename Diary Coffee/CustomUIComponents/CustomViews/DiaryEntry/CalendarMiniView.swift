//
//  CalendarMiniVie.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 30.10.2024.
//

import UIKit

class CalendarMiniView: UIView {
    
    var dismissHandler: (() -> Void)?
    var dateSelectedHandler: ((Date) -> Void)?
    private let selectedDate: Date

    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        super.init(frame: .zero)
        setupUI()
        datePicker.date = selectedDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.tintColor = AppColors.color3
        picker.overrideUserInterfaceStyle = .dark
        picker.minimumDate = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 1))
        picker.maximumDate = Date()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        button.setTitleColor(AppColors.color2, for: .normal)
        button.backgroundColor = AppColors.color20
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("ok", comment: ""), for: .normal)
        button.setTitleColor(AppColors.color2, for: .normal)
        button.backgroundColor = AppColors.color3
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupUI() {
        backgroundColor = AppColors.color1
        layer.cornerRadius = 15
        layer.masksToBounds = true

      
        addSubview(datePicker)
        addSubview(cancelButton)
        addSubview(okButton)

      
        
        NSLayoutConstraint.activate([
        
            datePicker.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            cancelButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            
            okButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            okButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            okButton.heightAnchor.constraint(equalToConstant: 44),
            okButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            
            okButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 10),
            okButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cancelButtonTapped() {
        dismissHandler?()
    }
    
    @objc private func okButtonTapped() {
        dateSelectedHandler?(datePicker.date)
    }
}
