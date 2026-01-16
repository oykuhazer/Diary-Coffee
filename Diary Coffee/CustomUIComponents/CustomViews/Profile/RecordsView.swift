//
//  RecordsView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 23.10.2024.
//

import UIKit

protocol RecordsViewDelegate: AnyObject {
    func showPhotoGallery()
}

class RecordsView: UIView {
    
    weak var delegate: RecordsViewDelegate?
    
    private var recordedDaysValueLabel: UILabel!
    private var photosValueLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("my_records", comment: "")

        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = AppColors.color5
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        let recordsStackView = UIStackView()
        recordsStackView.axis = .horizontal
        recordsStackView.distribution = .fillEqually
        recordsStackView.spacing = 16
        recordsStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(recordsStackView)
        
        let recordedDaysView = createCardView(
            title: NSLocalizedString("recorded_days", comment: ""),
            value: "0",
            imageName: "diary"
        )
        recordsStackView.addArrangedSubview(recordedDaysView)
        
        recordedDaysValueLabel = recordedDaysView.subviews.compactMap { $0 as? UILabel }.first { $0.font == UIFont.boldSystemFont(ofSize: 20) }
        
        let photosView = createCardView(
            title: NSLocalizedString("photos", comment: ""),
            value: "0",
            imageName: "photogalery"
        )
        recordsStackView.addArrangedSubview(photosView)
        
        photosValueLabel = photosView.subviews.compactMap { $0 as? UILabel }.first { $0.font == UIFont.boldSystemFont(ofSize: 20) }
        
        let photoGalleryCardView = createPhotoGalleryCardView(
            imageName: "photo",
            title: NSLocalizedString("photo_gallery", comment: "")
        )
        self.addSubview(photoGalleryCardView)
        
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
    
    func updateRecordedDays(value: String) {
        recordedDaysValueLabel?.text = value
    }
    
    func updatePhotos(value: String) {
        photosValueLabel?.text = value
    }
    
    private func createCardView(title: String, value: String, imageName: String) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = AppColors.color1
        cardView.layer.cornerRadius = 12
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = AppColors.color5
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = AppColors.color5
        valueLabel.font = UIFont.boldSystemFont(ofSize: 20)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView(image: UIImage(named: imageName))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(titleLabel)
        cardView.addSubview(valueLabel)
        cardView.addSubview(iconImageView)
        
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
    
    private func createPhotoGalleryCardView(imageName: String, title: String) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = AppColors.color1
        cardView.layer.cornerRadius = 12
        cardView.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView(image: UIImage(named: imageName))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = AppColors.color5
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.tintColor = AppColors.color5
        chevronImageView.contentMode = .scaleAspectFit
        
        cardView.addSubview(iconImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(chevronImageView)
        
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
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoGalleryTapped))
        cardView.addGestureRecognizer(tapGesture)
        
        return cardView
    }
    
    @objc private func photoGalleryTapped() {
        delegate?.showPhotoGallery()
    }
}
