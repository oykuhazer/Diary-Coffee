//
//  CoffeeDiaryCalendarCell.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 28.10.2024.
//

import UIKit

class CoffeeDiaryCalendarCell: UICollectionViewCell {
    private let diaryText = UILabel()
    private let circularView = UIView()
    private let coffeeTagView = TypeTagView(label: "Snack x7", iconName: "yogunlukdolu")
    private let coffeeTagView2 = TypeTagView(label: "Coffee x5", iconName: "yogunlukdolu")
    private let imageView = UIImageView(image: UIImage(named: "d"))
    private let lineView = UIView()
    private let dayLabel = UILabel()
    
    // Sticker alanları
    private let sticker1 = UIView()
    private let sticker2 = UIView()
    private let sticker3 = UIView()
    
    private let imageContainerView = UIView()
    private let image1Container = UIView()
    private let image2Container = UIView()
    private let image3Container = UIView()
    private let image1 = UIImageView(image: UIImage(named: "image1"))
    private let image2 = UIImageView(image: UIImage(named: "image2"))
    private let image3 = UIImageView(image: UIImage(named: "image3"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        backgroundColor = UIColor(red: 0.28, green: 0.20, blue: 0.15, alpha: 1.0)
        layer.cornerRadius = 12
        layer.masksToBounds = true

        circularView.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
        circularView.translatesAutoresizingMaskIntoConstraints = false
        circularView.layer.cornerRadius = 25
        circularView.layer.borderWidth = 1
        circularView.layer.borderColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0).cgColor
        circularView.layer.shadowColor = UIColor.black.cgColor
        circularView.layer.shadowOpacity = 0.15
        circularView.layer.shadowOffset = CGSize(width: 0, height: 2)
        circularView.layer.shadowRadius = 3
        contentView.addSubview(circularView)

        lineView.backgroundColor = UIColor(red: 0.4, green: 0.3, blue: 0.25, alpha: 1.0)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lineView)

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        circularView.addSubview(imageView)

        dayLabel.text = "12 Tue"
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        dayLabel.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)
        dayLabel.layer.cornerRadius = 5
        dayLabel.layer.masksToBounds = true
        contentView.addSubview(dayLabel)

        coffeeTagView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(coffeeTagView)
        
        coffeeTagView2.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(coffeeTagView2)

        diaryText.translatesAutoresizingMaskIntoConstraints = false
        diaryText.textAlignment = .justified
        diaryText.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        diaryText.numberOfLines = 0
        contentView.addSubview(diaryText)

        // Sticker alanlarını ayarlama
        [sticker1, sticker2, sticker3].forEach { sticker in
            sticker.translatesAutoresizingMaskIntoConstraints = false
            sticker.backgroundColor = UIColor(red: 0.9, green: 0.85, blue: 0.8, alpha: 1.0)
            sticker.layer.cornerRadius = 30  // Daire yapmak için yarıçap, width ve height ile uyumlu
            sticker.layer.shadowColor = UIColor.black.cgColor
            sticker.layer.shadowOpacity = 0.1
            sticker.layer.shadowOffset = CGSize(width: 1, height: 1)
            sticker.layer.shadowRadius = 2
            contentView.addSubview(sticker)
        }

        // Resimlerin içinde olacağı ana container view
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageContainerView)

        // Resimler için her bir container ayarları
        [image1Container, image2Container, image3Container].forEach { container in
            container.backgroundColor = UIColor(red: 0.9, green: 0.85, blue: 0.8, alpha: 1.0)
            container.layer.cornerRadius = 10
            container.layer.shadowColor = UIColor.black.cgColor
            container.layer.shadowOpacity = 0.1
            container.layer.shadowOffset = CGSize(width: 1, height: 1)
            container.layer.shadowRadius = 2
            container.translatesAutoresizingMaskIntoConstraints = false
            imageContainerView.addSubview(container)
        }

        // Her bir resim alanı için ayarlar
        [image1, image2, image3].enumerated().forEach { index, image in
            image.contentMode = .scaleAspectFill
            image.layer.cornerRadius = 8
            image.layer.masksToBounds = true
            image.translatesAutoresizingMaskIntoConstraints = false
            
            let container = [image1Container, image2Container, image3Container][index]
            container.addSubview(image)
            
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(equalToConstant: 50),
                image.heightAnchor.constraint(equalToConstant: 50),
                image.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                image.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
        }

        // Auto Layout ayarları
        NSLayoutConstraint.activate([
            circularView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            circularView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            circularView.widthAnchor.constraint(equalToConstant: 50),
            circularView.heightAnchor.constraint(equalToConstant: 50),

            imageView.centerXAnchor.constraint(equalTo: circularView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circularView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),

            dayLabel.topAnchor.constraint(equalTo: circularView.bottomAnchor, constant: 10),
            dayLabel.centerXAnchor.constraint(equalTo: circularView.centerXAnchor),
            dayLabel.widthAnchor.constraint(equalToConstant: 50),
            dayLabel.heightAnchor.constraint(equalToConstant: 20),

            lineView.leadingAnchor.constraint(equalTo: circularView.trailingAnchor, constant: 20),
            lineView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            lineView.widthAnchor.constraint(equalToConstant: 3),

            coffeeTagView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            coffeeTagView.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 20),
            coffeeTagView.heightAnchor.constraint(equalToConstant: 50),
            coffeeTagView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            coffeeTagView2.topAnchor.constraint(equalTo: coffeeTagView.bottomAnchor, constant: 20),
            coffeeTagView2.leadingAnchor.constraint(equalTo: coffeeTagView.leadingAnchor),
            coffeeTagView2.heightAnchor.constraint(equalTo: coffeeTagView.heightAnchor),
            coffeeTagView2.widthAnchor.constraint(equalTo: coffeeTagView.widthAnchor),

           

            // Sticker alanları için konumlandırma
            sticker1.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 20),
            sticker1.topAnchor.constraint(equalTo: coffeeTagView2.bottomAnchor, constant: 30),
            sticker1.widthAnchor.constraint(equalToConstant: 60),
            sticker1.heightAnchor.constraint(equalToConstant: 60),

            sticker2.leadingAnchor.constraint(equalTo: sticker1.trailingAnchor, constant: 20),
            sticker2.topAnchor.constraint(equalTo: coffeeTagView2.bottomAnchor, constant: 30),
            sticker2.widthAnchor.constraint(equalToConstant: 60),
            sticker2.heightAnchor.constraint(equalToConstant: 60),

            sticker3.leadingAnchor.constraint(equalTo: sticker2.trailingAnchor, constant: 20),
            sticker3.topAnchor.constraint(equalTo: coffeeTagView2.bottomAnchor, constant: 30),
            sticker3.widthAnchor.constraint(equalToConstant: 60),
            sticker3.heightAnchor.constraint(equalToConstant: 60),

            // imageContainerView ayarları
            imageContainerView.topAnchor.constraint(equalTo: diaryText.bottomAnchor, constant: 10),
            imageContainerView.leadingAnchor.constraint(equalTo: diaryText.leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: diaryText.trailingAnchor),
            imageContainerView.heightAnchor.constraint(equalToConstant: 70),

            // Her bir resim için container ayarları
            image1Container.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            image1Container.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            image1Container.widthAnchor.constraint(equalToConstant: 60),
            image1Container.heightAnchor.constraint(equalToConstant: 60),

            image2Container.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            image2Container.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            image2Container.widthAnchor.constraint(equalToConstant: 60),
            image2Container.heightAnchor.constraint(equalToConstant: 60),

            image3Container.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            image3Container.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            image3Container.widthAnchor.constraint(equalToConstant: 60),
            image3Container.heightAnchor.constraint(equalToConstant: 60),
            
            diaryText.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 20),
            diaryText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            diaryText.topAnchor.constraint(equalTo: sticker1.bottomAnchor, constant: 30)
        ])
    }

    func configure(with text: String) {
        diaryText.text = text
    }
}

