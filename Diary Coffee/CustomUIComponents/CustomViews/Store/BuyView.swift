//
//  BuyView.swift
//  Diary Coffee
//
//  Created by Öykü Hazer Ekinci on 23.12.2024.
//


import UIKit

class BuyView: UIView {
    
    weak var storeVC: StoreVC?
    var requiredBeans: Int = 0
    var isFromStoreStickerView: Bool = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = AppColors.color2
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = AppColors.color72
        label.textColor = AppColors.color5
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()


    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = AppColors.color2
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("buy_now", comment: ""), for: .normal)
        button.backgroundColor = AppColors.color2
        button.setTitleColor(AppColors.color3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark.circle.fill")
        let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        button.setImage(image?.withConfiguration(configuration), for: .normal)
        button.tintColor = AppColors.color4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let feedbackContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.color26
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var onBuyTapped: (() -> Void)?
    var onCloseTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = AppColors.color46
        addSubview(feedbackContainer)
        feedbackContainer.addSubview(titleLabel)
        feedbackContainer.addSubview(infoLabel)
        feedbackContainer.addSubview(descriptionLabel)
        feedbackContainer.addSubview(buyButton)
        feedbackContainer.addSubview(closeButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            feedbackContainer.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -200),
                    feedbackContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                    feedbackContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                    feedbackContainer.bottomAnchor.constraint(equalTo: buyButton.bottomAnchor, constant: 20),

                    titleLabel.topAnchor.constraint(equalTo: feedbackContainer.topAnchor, constant: 20),
                    titleLabel.leadingAnchor.constraint(equalTo: feedbackContainer.leadingAnchor, constant: 20),
                    titleLabel.trailingAnchor.constraint(equalTo: feedbackContainer.trailingAnchor, constant: -20),

                    closeButton.topAnchor.constraint(equalTo: feedbackContainer.topAnchor, constant: 10),
                    closeButton.trailingAnchor.constraint(equalTo: feedbackContainer.trailingAnchor, constant: -10),

                    descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
                    descriptionLabel.leadingAnchor.constraint(equalTo: feedbackContainer.leadingAnchor, constant: 20),
                    descriptionLabel.trailingAnchor.constraint(equalTo: feedbackContainer.trailingAnchor, constant: -20),

                    infoLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
                    infoLabel.centerXAnchor.constraint(equalTo: feedbackContainer.centerXAnchor),
                    infoLabel.widthAnchor.constraint(equalToConstant: 100),
                    infoLabel.heightAnchor.constraint(equalToConstant: 30),

                    buyButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 30),
                    buyButton.leadingAnchor.constraint(equalTo: feedbackContainer.leadingAnchor, constant: 20),
                    buyButton.trailingAnchor.constraint(equalTo: feedbackContainer.trailingAnchor, constant: -20),
                    buyButton.heightAnchor.constraint(equalToConstant: 50),
        ])

    }
    
    private func configureInfoLabel() {
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "coffeebeans")?.withRenderingMode(.alwaysOriginal)
        attachment.bounds = CGRect(x: 5, y: -3, width: 18, height: 18)
        let attachmentString = NSAttributedString(attachment: attachment)

        let textString = NSAttributedString(
            string: "   \(requiredBeans)",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 16)]
        )

        let combinedString = NSMutableAttributedString()
        combinedString.append(attachmentString)
        combinedString.append(textString)

        infoLabel.attributedText = combinedString
    }


    @objc private func buyButtonTapped() {
        guard let title = titleLabel.text, let description = descriptionLabel.text else {
            return
        }

        // 🔥 Eğer başlık "Classic" içeriyorsa boşlukları kaldırarak formatla
        let emotionCategory: String
        if title.contains("Classic") {
            emotionCategory = title.replacingOccurrences(of: " ", with: "")
        } else {
            emotionCategory = title
        }

        if isFromStoreStickerView {
            if UserProfile.shared.purchasedStickers.contains(where: { $0.category == emotionCategory && $0.description == description }) {
                NotificationCenter.default.post(
                    name: .showRequiredActionView,
                    object: nil,
                    userInfo: [
                        "title": title,
                        "message": NSLocalizedString("sticker_already_purchased", comment: ""),
                        "iconName": "signal"
                    ]
                )
                onCloseTapped?()
                return
            }
        } else {
            if UserProfile.shared.purchasedEmotions.contains(where: { $0.category == emotionCategory && $0.description == description }) {
                NotificationCenter.default.post(
                    name: .showRequiredActionView,
                    object: nil,
                    userInfo: [
                        "title": title,
                        "message": NSLocalizedString("emotion_already_purchased", comment: ""),
                        "iconName": "signal"
                    ]
                )
                onCloseTapped?()
                return
            }
        }

        let requiredBeans: Int
        if isFromStoreStickerView {
            requiredBeans = 350
        } else if title.contains("Classic") {
            requiredBeans = 250
        } else {
            requiredBeans = 300
        }

        let currentBeans = UserProfile.shared.quantityBeans ?? 0
        if currentBeans < requiredBeans {
            NotificationCenter.default.post(
                name: .showRequiredActionView,
                object: nil,
                userInfo: [
                    "title": "",
                    "message":  NSLocalizedString("not_enough_beans", comment: ""),
                    "iconName": "signal"
                ]
            )
            onCloseTapped?()
            return
        }

        let originalBeans = currentBeans
        let originalStickers = UserProfile.shared.purchasedStickers
        let originalEmotions = UserProfile.shared.purchasedEmotions

        UserProfile.shared.quantityBeans = currentBeans - requiredBeans

        var newSticker: Sticker?
        var newEmotion: Emotion?

        if isFromStoreStickerView {
            newSticker = Sticker(category: emotionCategory, description: description)
            UserProfile.shared.purchasedStickers.append(newSticker!)
        } else {
            newEmotion = Emotion(category: emotionCategory, description: description)
            UserProfile.shared.purchasedEmotions.append(newEmotion!)
        }

        let purchasedFeatures = PurchasedFeatures(
            stickers: newSticker != nil ? [newSticker!] : [],
            emotions: newEmotion != nil ? [newEmotion!] : []
        )

        let parameters = SaveUserProfileQuery(
            uuid: UserProfile.shared.uuid,
            gender: UserProfile.shared.gender ?? "N/A",
            name: UserProfile.shared.name ?? "N/A",
            birthDate: UserProfile.shared.birthDate?.description ?? "N/A",
            styleSelection: UserProfile.shared.styleSelection ?? "N/A",
            isNotificationEnabled: UserProfile.shared.isNotificationEnabled,
            notificationTime: UserProfile.shared.notificationTime?.description ?? "N/A",
            isPasscodeEnabled: UserProfile.shared.isPasscodeEnabled,
            passcodeType: UserProfile.shared.passcodeType ?? "N/A",
            passcodeCode: UserProfile.shared.passcodeCode ?? "N/A",
            language: UserProfile.shared.language ?? "English",
            quantityBeans: UserProfile.shared.quantityBeans ?? 0,
            profilePicture: UserProfile.shared.profilePicture ?? "N/A",
            purchasedFeatures: purchasedFeatures,
            premium: UserProfile.shared.premium,
            premiumType: UserProfile.shared.premiumType ?? "N/A",
            premiumStartDate: UserProfile.shared.premiumStartDate?.description ?? "N/A",
            premiumDaysLeft: UserProfile.shared.premiumDaysLeft ?? 0
        ).getBody()

        SaveUserProfileRequest.shared.saveUserProfile(in: self) { [weak self] result in
            switch result {
            case .success:
                NotificationCenter.default.post(
                    name: .showRequiredActionView,
                    object: nil,
                    userInfo: [
                        "title": title,
                        "message": NSLocalizedString("successfully_purchased", comment: ""),
                        "iconName": "success"
                    ]
                )
                NotificationCenter.default.post(name: .coffeeLabelDidUpdate, object: nil)
            case .failure:
               
                UserProfile.shared.quantityBeans = originalBeans
                UserProfile.shared.purchasedStickers = originalStickers
                UserProfile.shared.purchasedEmotions = originalEmotions
                NotificationCenter.default.post(name: .coffeeLabelDidUpdate, object: nil)
            }
        }

        onCloseTapped?()
    }


    @objc private func closeButtonTapped() {
        onCloseTapped?()
    }

    func configure(title: String, description: String, requiredBeans: Int, isFromStoreStickerView: Bool = false) {
        titleLabel.text = title
        descriptionLabel.text = description
        self.requiredBeans = requiredBeans
        configureInfoLabel()
        self.isFromStoreStickerView = isFromStoreStickerView
    }
}




