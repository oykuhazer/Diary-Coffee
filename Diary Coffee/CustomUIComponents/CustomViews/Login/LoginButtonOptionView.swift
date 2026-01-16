//
//  LoginButtonOptionView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 3.11.2024.
//

import UIKit

class LoginButtonOptionView: UIView {
    
    private let button = UIButton()
    private let imageView = UIImageView()
    private let label = UILabel()
    
    init(imageName: String, title: String, target: Any?, action: Selector) {
        super.init(frame: .zero)
        setupView(imageName: imageName, title: title, target: target, action: action)
    }
    
    public func getTitle() -> String {
           return label.text ?? ""
       }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView(imageName: String, title: String, target: Any?, action: Selector) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 4
        backgroundColor = .white
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(target, action: action, for: .touchUpInside)
        
        
        imageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
      
        label.text = title
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = AppColors.color80
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
      
        addSubview(imageView)
        addSubview(label)
        addSubview(button)
        
        
       
        NSLayoutConstraint.activate([
          
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
           
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
           
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

