//
//  BirthdayDatePickerView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class BirthdayDatePickerView: UIView {

    let datePicker = UIDatePicker()
    let selectButton = UIButton(type: .system)
    
    var selectedDate: Date? {
        didSet {
            updateDateLabel()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
   
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = AppColors.color2
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 4

        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 380),
            self.heightAnchor.constraint(equalToConstant: 250)
        ])
        
      
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .clear
        datePicker.tintColor = AppColors.color3
        datePicker.setValue(AppColors.color3, forKey: "textColor")
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

       
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 1950
        datePicker.minimumDate = calendar.date(from: dateComponents)
        
        let currentYear = calendar.component(.year, from: Date())
        dateComponents.year = currentYear - 7
        datePicker.maximumDate = calendar.date(from: dateComponents)

       
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.setTitle(NSLocalizedString("select_date", comment: ""), for: .normal)
        selectButton.backgroundColor = AppColors.color3
        selectButton.setTitleColor(AppColors.color2, for: .normal)
        selectButton.layer.cornerRadius = 10
        selectButton.layer.borderWidth = 2.0
        selectButton.layer.borderColor = UIColor.white.cgColor
        selectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        selectButton.addTarget(self, action: #selector(selectDateTapped), for: .touchUpInside)

        self.addSubview(datePicker)
        self.addSubview(selectButton)

        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            selectButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            selectButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            selectButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            selectButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            selectButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        datePicker.date = Date()
        selectedDate = datePicker.date
    }


    @objc private func dateChanged() {
        selectedDate = datePicker.date
    }

    @objc private func selectDateTapped() {
        if let birthdayButtonView = superview?.superview?.subviews.compactMap({ $0 as? BirthdayButtonView }).first {
            birthdayButtonView.updateButtonTitle(with: selectedDate ?? Date())
        }
        self.isHidden = true
    }
    
    private func updateDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: selectedDate ?? Date())
    }
}
