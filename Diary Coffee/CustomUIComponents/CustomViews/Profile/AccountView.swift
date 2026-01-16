//
//  AccountView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 23.10.2024.
//

import UIKit

class AccountView: UIView {
    private let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

 
    private func setupView() {
        self.backgroundColor = AppColors.color1
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 16

        let accountLabel = UILabel()
        accountLabel.text = NSLocalizedString("account", comment: "")
        accountLabel.textColor = AppColors.color5
        accountLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        accountLabel.textAlignment = .center
        accountLabel.translatesAutoresizingMaskIntoConstraints = false

        let circularView = UIView()
        circularView.backgroundColor = AppColors.color4
        circularView.translatesAutoresizingMaskIntoConstraints = false
        circularView.layer.cornerRadius = 30
        circularView.layer.borderWidth = 1
        circularView.layer.borderColor = AppColors.color5.cgColor
        circularView.layer.shadowColor = UIColor.black.cgColor
        circularView.layer.shadowOpacity = 0.15
        circularView.layer.shadowOffset = CGSize(width: 0, height: 2)
        circularView.layer.shadowRadius = 3

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        circularView.addSubview(imageView)

        let nameLabel = UILabel()
        nameLabel.text = "\(UserProfile.shared.name ?? "")"
        nameLabel.textColor = AppColors.color5
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let userIDLabel = UILabel()
        let uuidWithoutDashes = UserProfile.shared.uuid.replacingOccurrences(of: "-", with: "")
        let firstEightCharacters = String(uuidWithoutDashes.prefix(8))
        userIDLabel.text = String(format: NSLocalizedString("user_id", comment: ""), firstEightCharacters)
        userIDLabel.textColor = AppColors.color5
        userIDLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        userIDLabel.translatesAutoresizingMaskIntoConstraints = false

        let chevronButton = UIButton()
        chevronButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        chevronButton.tintColor = AppColors.color5
        chevronButton.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(circularView)
        self.addSubview(nameLabel)
        self.addSubview(userIDLabel)
        self.addSubview(chevronButton)
        self.addSubview(accountLabel)

        NSLayoutConstraint.activate([
            accountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -40),
            accountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            
            circularView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            circularView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circularView.widthAnchor.constraint(equalToConstant: 60),
            circularView.heightAnchor.constraint(equalToConstant: 60),
            
            imageView.centerXAnchor.constraint(equalTo: circularView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circularView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: circularView.trailingAnchor, constant: 30),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15),
            
            userIDLabel.leadingAnchor.constraint(equalTo: circularView.trailingAnchor, constant: 30),
            userIDLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15),

            chevronButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            chevronButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            chevronButton.widthAnchor.constraint(equalToConstant: 20),
            chevronButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

  
    func configure(with profilePictureURL: String?) {
        guard let urlString = profilePictureURL, let url = URL(string: urlString) else {
            imageView.image = UIImage(named: "a")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "a")
                    self.updateImageSize(isClassicSet: false)
                }
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    let isClassicSet = urlString.contains("ClassicSet")
                    self.imageView.image = image
                    self.updateImageSize(isClassicSet: isClassicSet)
                }
            } else {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "a")
                    self.updateImageSize(isClassicSet: false)
                }
            }
        }.resume()
    }

    private func updateImageSize(isClassicSet: Bool) {
        NSLayoutConstraint.deactivate(imageView.constraints)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: imageView.superview!.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageView.superview!.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: isClassicSet ? 40 : 70),
            imageView.heightAnchor.constraint(equalToConstant: isClassicSet ? 40 : 70)
        ])
    }


}
