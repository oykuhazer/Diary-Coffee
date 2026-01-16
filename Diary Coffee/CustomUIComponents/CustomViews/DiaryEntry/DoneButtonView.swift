//
//  DoneButtonView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 5.11.2024.
//

import UIKit

class DoneButtonView: UIView {
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("done", comment: ""), for: .normal)
        button.backgroundColor = AppColors.color2
        button.setTitleColor(AppColors.color3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    
    var onDoneTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = AppColors.color26
        self.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            doneButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func doneButtonTapped() {
        onDoneTapped?()
    }
}
