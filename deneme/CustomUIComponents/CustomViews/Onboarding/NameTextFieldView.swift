//
//  NameTextFieldView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class NameTextFieldView: UIView {

    let textField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // View genel ayarları
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0).cgColor
        
        // TextField ayarları
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your name"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        textField.backgroundColor = .clear
        textField.borderStyle = .none

        // Placeholder renk ayarı
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)]
        textField.attributedPlaceholder = NSAttributedString(string: "Enter your name", attributes: placeholderAttributes)

        // Sol ikonu ekleme
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let identityIcon = UIImageView(image: UIImage(systemName: "person.text.rectangle.fill"))
        identityIcon.tintColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        identityIcon.contentMode = .scaleAspectFit
        identityIcon.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        paddingView.addSubview(identityIcon)
        textField.leftView = paddingView
        textField.leftViewMode = .always

        // Alt görünümü ekleme
        self.addSubview(textField)

        // TextField Constraints
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}
