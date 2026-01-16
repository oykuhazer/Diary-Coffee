//
//  CoffeeMemorySelectorView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 29.10.2024.
//

import UIKit

class CoffeeMemorySelectorView: UIView {

   
    private let memories = [
        ("Morning", "Morning"),
        ("Camp", "Camp"),
        ("Chat", "Chat"),
        ("Dessert", "Dessert"),
        ("Evening", "Evening"),
        ("Afternoon", "Afternoon"),
        ("Friends", "Friends"),
        ("Inspiration", "Inspiration"),
        ("Romantic", "Romantic"),
        ("Reading", "Reading"),
        ("Trip", "Trip"),
        ("Work Break", "Work Break")

    ]
    
    private let columns = 4
    private let padding: CGFloat = 15
    private var selectedView: UIView?
    private var selectedMemoryIndex: Int?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    var isMemorySelected: Bool {
           return selectedMemoryIndex != nil
       }

    
    private func setupView() {
        self.backgroundColor = AppColors.color26
        self.layer.cornerRadius = 10
        
       
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("coffee_moments", comment: "")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = AppColors.color2
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
       
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.spacing = padding
        gridStackView.distribution = .fillEqually
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(gridStackView)
        
       
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            gridStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            gridStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            gridStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            gridStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)
        ])
        
        var rowStackView: UIStackView?
        
        for (index, (imageName, label)) in memories.enumerated() {
            if index % columns == 0 {
                rowStackView = UIStackView()
                rowStackView?.axis = .horizontal
                rowStackView?.spacing = padding
                rowStackView?.distribution = .fillEqually
                gridStackView.addArrangedSubview(rowStackView!)
            }
            
            let memoryView = createMemoryView(imageName: imageName, label: label)
            memoryView.tag = index
            rowStackView?.addArrangedSubview(memoryView)
        }
    }
    
    private func createMemoryView(imageName: String, label: String) -> UIView {
        let containerView = UIView()
        
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = AppColors.color24
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = AppColors.color7.cgColor
        imageView.layer.borderWidth = 2

        containerView.addSubview(imageView)
        
        let labelView = UILabel()
        labelView.text = label
        labelView.font = UIFont.boldSystemFont(ofSize: 10)
        labelView.textColor = AppColors.color2
        labelView.textAlignment = .center
        labelView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(labelView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            labelView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            labelView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            labelView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
        
        return containerView
    }
    
    func getSelectedMemory() -> String? {
            guard let index = selectedMemoryIndex else { return nil }
            return memories[index].1
        }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view else { return }
        
      
        if let previousSelectedView = self.selectedView {
            resetSelection(for: previousSelectedView)
        }

      
        self.selectedView = selectedView
        selectedMemoryIndex = selectedView.tag
        applySelection(for: selectedView)
        
        
        if let selectedMemory = getSelectedMemory() {
           
        }
    }

    
   
    private func applySelection(for view: UIView) {
        if let imageView = view.subviews.first as? UIImageView,
           let labelView = view.subviews.last as? UILabel {
          
            imageView.layer.borderColor = AppColors.color35.cgColor
            imageView.layer.borderWidth = 4
            imageView.layer.shadowColor = AppColors.color40.cgColor
            imageView.layer.shadowOpacity = 0.6
            imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
            imageView.layer.shadowRadius = 8
            
           
            labelView.textColor = AppColors.color40
            labelView.layer.shadowColor = UIColor.black.cgColor
            labelView.layer.shadowRadius = 3
            labelView.layer.shadowOpacity = 0.5
            labelView.layer.shadowOffset = CGSize(width: 1, height: 1)
            
           
            UIView.animate(withDuration: 0.3, animations: {
                labelView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                labelView.attributedText = NSAttributedString(
                    string: labelView.text ?? "",
                    attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
                )
            }
        }
    }
    
 
    private func resetSelection(for view: UIView) {
        if let imageView = view.subviews.first as? UIImageView,
           let labelView = view.subviews.last as? UILabel {
            
            imageView.layer.borderColor = AppColors.color7.cgColor
            imageView.layer.borderWidth = 2
            imageView.layer.shadowColor = UIColor.black.cgColor
            imageView.layer.shadowOpacity = 0.3
            imageView.layer.shadowOffset = CGSize(width: 3, height: 3)
            imageView.layer.shadowRadius = 4
            
           
            labelView.textColor = AppColors.color2
            labelView.layer.shadowOpacity = 0
            labelView.transform = .identity
            labelView.attributedText = NSAttributedString(string: labelView.text ?? "")
        }
    }
}
