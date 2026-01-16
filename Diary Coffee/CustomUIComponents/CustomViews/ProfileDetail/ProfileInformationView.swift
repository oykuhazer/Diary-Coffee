//
//  ProfileInformationView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 29.11.2024.
//

import UIKit

class ProfileInformationView: UIView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func addProfileItem(iconName: String, title: String, value: String, actionIconName: String, action: (() -> Void)? = nil) {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        container.addGestureRecognizer(tapGesture)
        container.accessibilityIdentifier = title
        
        let iconView = UIImageView(image: UIImage(systemName: iconName))
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = AppColors.color7
        iconView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = AppColors.color5
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.textColor = AppColors.color7
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        let actionIconView = UIImageView(image: UIImage(systemName: actionIconName))
        actionIconView.translatesAutoresizingMaskIntoConstraints = false
        actionIconView.contentMode = .scaleAspectFit
        actionIconView.tintColor = AppColors.color7
        actionIconView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        actionIconView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let labelStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 4
        labelStack.alignment = .leading
        labelStack.translatesAutoresizingMaskIntoConstraints = false

        let hStack = UIStackView(arrangedSubviews: [iconView, labelStack, actionIconView])
        hStack.axis = .horizontal
        hStack.spacing = 16
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(hStack)
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: container.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(container)

       
        container.tag = stackView.arrangedSubviews.count - 1
        container.action = action
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if let action = sender.view?.action {
            action()
        }
    }
}

extension UIView {
    private static var actionKey = "actionKey"
    var action: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &UIView.actionKey) as? (() -> Void)
        }
        set {
            objc_setAssociatedObject(self, &UIView.actionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
