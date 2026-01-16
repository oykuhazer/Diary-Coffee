//
//  PremiumAnalysisView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 18.11.2024.
//

import UIKit

class PremiumAnalysisView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "crown"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("premium_analysis", comment: "")
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = AppColors.color5
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(imageView)
        addSubview(label)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -40),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
