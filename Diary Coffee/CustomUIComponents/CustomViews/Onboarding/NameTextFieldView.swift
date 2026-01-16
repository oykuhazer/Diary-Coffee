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
       
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = AppColors.color2
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = AppColors.color3.cgColor
        
       
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = NSLocalizedString("enter_your_name", comment: "")
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = AppColors.color3
        textField.backgroundColor = .clear
        textField.borderStyle = .none

      
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor: AppColors.color3]
        let placeholderText = NSLocalizedString("enter_your_name", comment: "")
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)

      
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let identityIcon = UIImageView(image: UIImage(systemName: "person.text.rectangle.fill"))
        identityIcon.tintColor = AppColors.color3
        identityIcon.contentMode = .scaleAspectFit
        identityIcon.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        paddingView.addSubview(identityIcon)
        textField.leftView = paddingView
        textField.leftViewMode = .always

       
        self.addSubview(textField)

       
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}
