//
//  PinContainerView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 3.11.2024.
//

import UIKit

class PinContainerView: UIView {
    let titleLabel = UILabel()
    let pinStackView = UIStackView()
    let pinTextFields: [UITextField] = (1...4).map { _ in
        let textField = UITextField()
        textField.backgroundColor = AppColors.color4
        textField.layer.cornerRadius = 10
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        textField.textColor = AppColors.color2
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = false
        return textField
    }
    let setPinButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupSubviews()
    }
    
    private func setupView() {
        self.backgroundColor = AppColors.color38
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupSubviews() {
       
        titleLabel.text = NSLocalizedString("pin_code", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        titleLabel.textColor = AppColors.color3
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
       
        pinStackView.axis = .horizontal
        pinStackView.distribution = .fillEqually
        pinStackView.spacing = 20
        pinStackView.translatesAutoresizingMaskIntoConstraints = false
        pinTextFields.forEach { textField in
            textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
            textField.widthAnchor.constraint(equalToConstant: 60).isActive = true
            pinStackView.addArrangedSubview(textField)
        }
        addSubview(pinStackView)
        
       
        setPinButton.setTitle(NSLocalizedString("set_pin", comment: ""), for: .normal)
        setPinButton.backgroundColor = AppColors.color3
        setPinButton.setTitleColor(AppColors.color2, for: .normal)
        setPinButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        setPinButton.layer.cornerRadius = 10
        setPinButton.translatesAutoresizingMaskIntoConstraints = false
       setPinButton.addTarget(nil, action: #selector(PinCodeLoginVC.setPinButtonTapped), for: .touchUpInside)

        addSubview(setPinButton)
        
     
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            pinStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            pinStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            setPinButton.topAnchor.constraint(equalTo: pinStackView.bottomAnchor, constant: 30),
            setPinButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            setPinButton.widthAnchor.constraint(equalToConstant: 200),
            setPinButton.heightAnchor.constraint(equalToConstant: 60),
            setPinButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
}
