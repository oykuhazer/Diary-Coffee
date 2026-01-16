//
//  TypeTagView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 28.10.2024.
//

import UIKit

class DiaryListTagView: UIView {

    private let circularBackgroundView = UIView()
    let iconImageView = UIImageView()

    init(iconName: String) {
        super.init(frame: .zero)
        setupCircularBackgroundView(iconName: iconName)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCircularBackgroundView(iconName: String) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            AppColors.color49.cgColor,
            AppColors.color10.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        circularBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        circularBackgroundView.layer.cornerRadius = 25
        circularBackgroundView.clipsToBounds = true
        circularBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(circularBackgroundView)

        iconImageView.image = UIImage(named: iconName)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        circularBackgroundView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            circularBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circularBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circularBackgroundView.widthAnchor.constraint(equalToConstant: 50),
            circularBackgroundView.heightAnchor.constraint(equalToConstant: 50),

            iconImageView.centerXAnchor.constraint(equalTo: circularBackgroundView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: circularBackgroundView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
