//
//  LaunchVC.swift
//  Diary Coffee
//
//  Created by Öykü Hazer Ekinci on 31.01.2025.
//

import UIKit

class LaunchVC: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "AppIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let customTextView: CustomTextView = {
        let textView = CustomTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.color3
        view.addSubview(logoImageView)
        view.addSubview(customTextView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            customTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customTextView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -5),
            customTextView.widthAnchor.constraint(equalToConstant: 300),
            customTextView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}

class CustomTextView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let text = "DiaryCoffee"
        
    
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "ChalkboardSE-Bold", size: 30) ?? UIFont.systemFont(ofSize: 30),
            .foregroundColor: AppColors.color89
        ]
        
     
        let textSize = text.size(withAttributes: attributes)
        let textRect = CGRect(
            x: (rect.width - textSize.width) / 2,
            y: (rect.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
      
        text.draw(in: textRect, withAttributes: attributes)
    }
}

