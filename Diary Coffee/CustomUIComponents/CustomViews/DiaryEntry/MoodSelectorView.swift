//
//  MoodSelectorView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 29.10.2024.
//

import UIKit

class MoodSelectorView: UIView {
    
    private var images: [String] = []
    private var buttons: [UIButton] = []
    private var selectedIndex: Int? = nil {
          didSet {
              if let index = selectedIndex {
                
              } else {
                
              }
          }
      }
    
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let indicatorView: IndicatorView = {
         let indicator = IndicatorView()
         indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.indicatorColor = AppColors.color5
         return indicator
     }()
    
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
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("coffee_mood_today", comment: "")
        titleLabel.textColor = AppColors.color2
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
     
        addSubview(buttonStack)
        addSubview(indicatorView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            buttonStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                       indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 15),
                       indicatorView.widthAnchor.constraint(equalToConstant: 50),
                       indicatorView.heightAnchor.constraint(equalToConstant: 50),
                   ])
                   
           indicatorView.isHidden = true
       
    }
    
    func configure(with images: [String], completion: (() -> Void)? = nil) {
        guard !images.isEmpty else {
            completion?()
            return
        }
        
        self.images = images
        
        indicatorView.show()
        buttonStack.isHidden = true
        
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        let group = DispatchGroup()

        images.enumerated().forEach { (index, imageURL) in
            group.enter()
            let button = UIButton(type: .system)
            button.backgroundColor = .clear
            button.layer.cornerRadius = 25
            button.clipsToBounds = true
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false

            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            if let url = URL(string: imageURL) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                          
                            let imageSize = imageURL.contains("ClassicSet") ? CGSize(width: 35, height: 35) : CGSize(width: 100, height: 100)
                            let resizedImage = image.resized(to: imageSize)
                            button.setImage(resizedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
                        }
                    }
                    group.leave()
                }
            } else {
                group.leave()
            }

            buttonStack.addArrangedSubview(button)
            buttons.append(button)
        }

        group.notify(queue: .main) {
            self.indicatorView.hide()
            self.buttonStack.isHidden = false
            completion?()
        }
    }


    
    func setSelectedMood(at index: Int) {
        guard index >= 0 && index < buttons.count else {
          
            return
        }
        
     
        if let selectedIndex = selectedIndex {
            buttons[selectedIndex].backgroundColor = .clear
        }
        
     
        selectedIndex = index
        buttons[index].backgroundColor = AppColors.color4
    }
    
    func getSelectedMood() -> String? {
        guard let selectedIndex = selectedIndex else { return nil }
        return images[selectedIndex]
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if let selectedIndex = selectedIndex {
            buttons[selectedIndex].backgroundColor = .clear
        }
        selectedIndex = sender.tag
        sender.backgroundColor = AppColors.color4
        
     
    }
}
