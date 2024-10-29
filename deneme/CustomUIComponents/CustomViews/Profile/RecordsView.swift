//
//  RecordsView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 23.10.2024.
//

import UIKit

class RecordsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .clear
       
        let titleLabel = UILabel()
        titleLabel.text = "My records"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        // Stack view to hold the cards for recorded days and photos
        let recordsStackView = UIStackView()
        recordsStackView.axis = .horizontal
        recordsStackView.distribution = .fillEqually
        recordsStackView.spacing = 16
        recordsStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(recordsStackView)
        
        // Recorded Days card using 'diary' image from assets
        let recordedDaysView = createCardView(title: "Recorded days", value: "2", imageName: "diary")
        recordsStackView.addArrangedSubview(recordedDaysView)
        
        // Photos card using 'photogalery' image from assets
        let photosView = createCardView(title: "Photos", value: "1", imageName: "photogalery")
        recordsStackView.addArrangedSubview(photosView)
        
        // Photo gallery card view using 'photo' image from assets with chevron.right
        let photoGalleryCardView = createPhotoGalleryCardView(imageName: "photo", title: "Photo Gallery")
        self.addSubview(photoGalleryCardView)
        
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -5),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            
            recordsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            recordsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            recordsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            recordsStackView.heightAnchor.constraint(equalToConstant: 120),
            
            photoGalleryCardView.topAnchor.constraint(equalTo: recordsStackView.bottomAnchor, constant: 16),
            photoGalleryCardView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoGalleryCardView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoGalleryCardView.heightAnchor.constraint(equalToConstant: 60),
            photoGalleryCardView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
    
    func createCardView(title: String, value: String, imageName: String) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)
        cardView.layer.cornerRadius = 12
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)
        valueLabel.font = UIFont.boldSystemFont(ofSize: 20)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Using the image from assets
        let iconImageView = UIImageView(image: UIImage(named: imageName))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(titleLabel)
        cardView.addSubview(valueLabel)
        cardView.addSubview(iconImageView)
        
        // Constraints for card elements
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            
            valueLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -5),
            valueLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            
            iconImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15),
            iconImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return cardView
    }

    // New function to create the Photo Gallery card view with chevron.right on the right side
    func createPhotoGalleryCardView(imageName: String, title: String) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)
        cardView.layer.cornerRadius = 12
        cardView.translatesAutoresizingMaskIntoConstraints = false

        // Image on the left
        let iconImageView = UIImageView(image: UIImage(named: imageName))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        // Title on the right of the image with semibold font
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)  // Semibold font
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Chevron on the right side
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.tintColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)
        chevronImageView.contentMode = .scaleAspectFit
        
        // Adding the views
        cardView.addSubview(iconImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(chevronImageView)
        
        // Constraints for image, title, and chevron
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return cardView
    }
}
