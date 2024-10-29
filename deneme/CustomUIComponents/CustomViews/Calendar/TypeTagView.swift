//
//  TypeTagView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 28.10.2024.
//

import UIKit

class TypeTagView: UIView {

    private let tagContainerView = UIView()
    private let circularBackgroundView = UIView()
    private let iconImageView = UIImageView()
    private let tagLabel = UILabel()

    init(label: String, iconName: String) {
        super.init(frame: .zero)
        setupTagContainerView()
        setupCircularBackgroundView(iconName: iconName)
        setupTagLabel(text: label)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTagContainerView() {
        tagContainerView.backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.94, alpha: 1.0)
        tagContainerView.layer.cornerRadius = 24 // Yüksekliği arttırıldığı için köşe radius'u arttırıldı
        tagContainerView.layer.borderColor = UIColor(red: 0.9, green: 0.85, blue: 0.8, alpha: 1.0).cgColor
        tagContainerView.layer.borderWidth = 1
        tagContainerView.layer.shadowColor = UIColor.black.cgColor
        tagContainerView.layer.shadowOpacity = 0.1
        tagContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        tagContainerView.layer.shadowRadius = 6
        tagContainerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tagContainerView)

        NSLayoutConstraint.activate([
            tagContainerView.topAnchor.constraint(equalTo: topAnchor),
            tagContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupCircularBackgroundView(iconName: String) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.92, green: 0.84, blue: 0.75, alpha: 1.0).cgColor,
            UIColor(red: 0.8, green: 0.7, blue: 0.6, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 32, height: 32) // Genişlik ve yükseklik arttırıldı
        circularBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        circularBackgroundView.layer.cornerRadius = 16 // Radius orantılı olarak arttırıldı
        circularBackgroundView.clipsToBounds = true
        circularBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        tagContainerView.addSubview(circularBackgroundView)

        iconImageView.image = UIImage(named: iconName)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        circularBackgroundView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            circularBackgroundView.leadingAnchor.constraint(equalTo: tagContainerView.leadingAnchor, constant: 12),
            circularBackgroundView.centerYAnchor.constraint(equalTo: tagContainerView.centerYAnchor),
            circularBackgroundView.widthAnchor.constraint(equalToConstant: 32), // Genişlik arttırıldı
            circularBackgroundView.heightAnchor.constraint(equalToConstant: 32), // Yükseklik arttırıldı

            iconImageView.centerXAnchor.constraint(equalTo: circularBackgroundView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: circularBackgroundView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20), // İkon genişliği arttırıldı
            iconImageView.heightAnchor.constraint(equalToConstant: 20) // İkon yüksekliği arttırıldı
        ])
    }

    private func setupTagLabel(text: String) {
        tagLabel.text = text
        tagLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium) // Font boyutu arttırıldı
        tagLabel.textColor = UIColor(red: 0.4, green: 0.3, blue: 0.2, alpha: 1.0)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagContainerView.addSubview(tagLabel)

        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: circularBackgroundView.trailingAnchor, constant: 10),
            tagLabel.centerYAnchor.constraint(equalTo: tagContainerView.centerYAnchor),
            tagLabel.trailingAnchor.constraint(equalTo: tagContainerView.trailingAnchor, constant: -12)
        ])
    }
}
