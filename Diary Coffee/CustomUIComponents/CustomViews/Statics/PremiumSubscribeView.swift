//
//  PremiumSubscribeView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 18.11.2024.
//
import UIKit


protocol PremiumSubscribeViewDelegate: AnyObject {
    func didTapSubscribeButton()
}

class PremiumSubscribeView: UIView {

    weak var delegate: PremiumSubscribeViewDelegate?

    private let crownImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "crown"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("subscribe_to_premium", comment: "")
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = AppColors.color2
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let subscribeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("premium_pass", comment: ""), for: .normal)
        button.setTitleColor(AppColors.color5, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = AppColors.color20
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            AppColors.color69.cgColor,
            AppColors.color46.cgColor,
            AppColors.color70.cgColor
        ]
        gradient.locations = [0.0, 0.4, 0.7]
        return gradient
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
        layer.cornerRadius = 16
        layer.masksToBounds = true

        layer.insertSublayer(gradientLayer, at: 0)

       
        addSubview(crownImageView)
        addSubview(label)
        addSubview(subscribeButton)

        NSLayoutConstraint.activate([
            crownImageView.topAnchor.constraint(equalTo: topAnchor, constant: -20),
            crownImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            crownImageView.widthAnchor.constraint(equalToConstant: 60),
            crownImageView.heightAnchor.constraint(equalToConstant: 60),

            label.topAnchor.constraint(equalTo: crownImageView.bottomAnchor, constant: -5),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            subscribeButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            subscribeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            subscribeButton.widthAnchor.constraint(equalToConstant: 200),
            subscribeButton.heightAnchor.constraint(equalToConstant: 44),
            subscribeButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20)
        ])

        subscribeButton.addTarget(self, action: #selector(subscribeButtonTapped), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    @objc private func subscribeButtonTapped() {
        delegate?.didTapSubscribeButton()
    }
}
