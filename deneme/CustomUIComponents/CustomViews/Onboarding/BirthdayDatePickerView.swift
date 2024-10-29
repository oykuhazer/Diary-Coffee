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
        self.backgroundColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 4

        // Genişlik ve yükseklik kısıtlamalarını ayarla
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 380), // Sabit genişlik
            self.heightAnchor.constraint(equalToConstant: 250) // Sabit yükseklik
        ])
        
        // Date Picker ayarları
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .clear
        datePicker.tintColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        datePicker.setValue(UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0), forKey: "textColor")
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // Select Button ayarları
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.setTitle("Select Date", for: .normal)
        selectButton.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        selectButton.setTitleColor(UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0), for: .normal)
        selectButton.layer.cornerRadius = 10
        selectButton.layer.borderWidth = 2.0
        selectButton.layer.borderColor = UIColor.white.cgColor
        selectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        selectButton.addTarget(self, action: #selector(selectDateTapped), for: .touchUpInside)

        self.addSubview(datePicker)
        self.addSubview(selectButton)

        // Layout Constraints
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
