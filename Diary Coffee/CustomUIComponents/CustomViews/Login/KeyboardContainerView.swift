//
//  KeyboardContainerView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 3.11.2024.
//

import UIKit

class KeyboardContainerView: UIView {
    let numberPadStackView = UIStackView()
    weak var delegate: KeyboardContainerViewDelegate?
    
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
        self.backgroundColor = AppColors.color39
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSubviews() {
        numberPadStackView.axis = .vertical
        numberPadStackView.distribution = .equalSpacing
        numberPadStackView.spacing = 15
        numberPadStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(numberPadStackView)
        
        setupNumberPad()
        
        NSLayoutConstraint.activate([
            numberPadStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            numberPadStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            numberPadStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            numberPadStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupNumberPad() {
        let buttons = (1...9).map { createNumberButton(with: "\($0)") }
        let deleteButton = createDeleteButton()
        let zeroButton = createNumberButton(with: "0")
        
        let rows: [[UIButton]] = [
            Array(buttons[0...2]),
            Array(buttons[3...5]),
            Array(buttons[6...8])  
        ]
        
        for row in rows {
            let rowStackView = UIStackView(arrangedSubviews: row)
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 10
            numberPadStackView.addArrangedSubview(rowStackView)
        }
        
        let lastRowStackView = UIStackView(arrangedSubviews: [UIView(), zeroButton, deleteButton])
        lastRowStackView.axis = .horizontal
        lastRowStackView.distribution = .fillEqually
        lastRowStackView.spacing = 10
        numberPadStackView.addArrangedSubview(lastRowStackView)
    }
    
    private func createNumberButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(AppColors.color2, for: .normal)
        button.backgroundColor = AppColors.color3
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func createDeleteButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("⌫", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.setTitleColor(AppColors.color2, for: .normal)
        button.backgroundColor = AppColors.color4
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }
    
    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let number = sender.title(for: .normal) else { return }
        delegate?.didTapNumberButton(number)
    }
    
    @objc private func deleteButtonTapped() {
        delegate?.didTapDeleteButton()
    }
}
