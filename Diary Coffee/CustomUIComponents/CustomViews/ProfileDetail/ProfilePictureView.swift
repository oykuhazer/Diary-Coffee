//
//  ProfilePictureView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 29.11.2024.
//

import UIKit

class ProfilePictureView: UIView {

    private let circularView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.color4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 60
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColors.color5.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "a"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let changeLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("change_profile_picture", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = AppColors.color5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private var imageWidthConstraint: NSLayoutConstraint!
    private var imageHeightConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupNotificationObserver()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupNotificationObserver()
    }

    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleProfilePictureChange(_:)),
            name: .profilePictureChanged,
            object: nil
        )
    }

    @objc private func handleProfilePictureChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let url = userInfo["url"] as? String else { return }
        updateProfileImage(url: url)
    }

    private func setupView() {
        addSubview(circularView)
        circularView.addSubview(imageView)
        addSubview(changeLabel)

        imageWidthConstraint = imageView.widthAnchor.constraint(equalTo: circularView.widthAnchor, multiplier: 0.9)
        imageHeightConstraint = imageView.heightAnchor.constraint(equalTo: circularView.heightAnchor, multiplier: 0.9)

        NSLayoutConstraint.activate([
            circularView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circularView.topAnchor.constraint(equalTo: topAnchor),
            circularView.widthAnchor.constraint(equalToConstant: 120),
            circularView.heightAnchor.constraint(equalToConstant: 120),
            imageView.centerXAnchor.constraint(equalTo: circularView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circularView.centerYAnchor),
            imageWidthConstraint,
            imageHeightConstraint,
            changeLabel.topAnchor.constraint(equalTo: circularView.bottomAnchor, constant: 20),
            changeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    func updateProfileImage(url: String?) {
        guard let url = url, let imageUrl = URL(string: url) else { return }

       
        let shouldShrink = url.contains("ClassicSet")

        DispatchQueue.main.async {
            self.imageWidthConstraint.isActive = false
            self.imageHeightConstraint.isActive = false

            let multiplier: CGFloat = shouldShrink ? 0.6 : 1.0
            self.imageWidthConstraint = self.imageView.widthAnchor.constraint(equalTo: self.circularView.widthAnchor, multiplier: multiplier)
            self.imageHeightConstraint = self.imageView.heightAnchor.constraint(equalTo: self.circularView.heightAnchor, multiplier: multiplier)

            self.imageWidthConstraint.isActive = true
            self.imageHeightConstraint.isActive = true

            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }

        URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = nil
                self.imageView.image = image
            }
        }.resume()
    }
}
