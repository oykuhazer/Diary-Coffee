//
//  PhotoView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 30.10.2024.
//

import UIKit

class PhotoView: UIView, PhotoManagerDelegate {
    private let photoManager = PhotoManager()
    private var selectedSquareView: UIView?
    private var uploadedPhotos: [PhotoInfo] = []
    private var isPremiumUser: Bool = false

    var hasPhotos: Bool {
        return !uploadedPhotos.isEmpty
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        photoManager.delegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        photoManager.delegate = self
    }

    func configure(with userProfile: GetUserProfileInformationResponse?) {
       
        isPremiumUser = userProfile?.userProfileInfo?.premium ?? false
        
     
        if let premiumStatus = userProfile?.userProfileInfo?.premium {
        
        } else {
           
        }
        
        setupView()
    }


    private func setupView() {
        self.subviews.forEach { $0.removeFromSuperview() }
        self.backgroundColor = AppColors.color26
        self.layer.cornerRadius = 10
        self.clipsToBounds = true

        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("coffee_moments_in_photos", comment: "")
        titleLabel.textColor = AppColors.color2
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 250)
        ])

        let squareSize: CGFloat = 90
        let squareColor = AppColors.color20

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 28
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)

        for index in 0..<3 {
            let squareView = UIView()
            squareView.backgroundColor = squareColor
            squareView.layer.cornerRadius = 8
            squareView.translatesAutoresizingMaskIntoConstraints = false
            squareView.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
            squareView.heightAnchor.constraint(equalToConstant: squareSize).isActive = true

            let iconButton = UIButton(type: .system)
            iconButton.setImage(UIImage(systemName: "camera.shutter.button.fill"), for: .normal)
            iconButton.tintColor = AppColors.color2
            iconButton.translatesAutoresizingMaskIntoConstraints = false
            iconButton.tag = index
            iconButton.addTarget(self, action: #selector(squareViewTapped(_:)), for: .touchUpInside)
            squareView.addSubview(iconButton)

            NSLayoutConstraint.activate([
                iconButton.centerXAnchor.constraint(equalTo: squareView.centerXAnchor),
                iconButton.centerYAnchor.constraint(equalTo: squareView.centerYAnchor)
            ])

            stackView.addArrangedSubview(squareView)
        }

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 20)
        ])
    }

    @objc private func squareViewTapped(_ sender: UIButton) {
        let squareIndex = sender.tag
       

        if !isPremiumUser && squareIndex > 0 {
            
            showPremiumVC()
        } else {
           
            selectedSquareView = sender.superview
            openPhotoSelection()
        }
    }

    private func showPremiumVC() {
        if let parentVC = self.parentViewController {
            let premiumVC = PremiumVC()
            premiumVC.modalPresentationStyle = .overCurrentContext
            premiumVC.modalTransitionStyle = .crossDissolve
            parentVC.present(premiumVC, animated: true)
        }
    }

    private func openPhotoSelection() {
        if let parentVC = self.parentViewController {
            let photoSelectView = PhotoSelectView()
            photoSelectView.modalPresentationStyle = .overCurrentContext
            photoSelectView.modalTransitionStyle = .crossDissolve

            photoSelectView.photoSelectCompletion = { [weak self] selection in
                guard let self = self else { return }
                parentVC.dismiss(animated: true) {
                    if selection == NSLocalizedString("camera", comment: "")  {
                        self.photoManager.openCamera(from: parentVC)
                    } else if selection == NSLocalizedString("album", comment: "") {
                        self.photoManager.openPhotoLibrary(from: parentVC)
                    }
                }
            }

            parentVC.definesPresentationContext = true
            parentVC.present(photoSelectView, animated: true)
        }
    }

    func photoManagerDidSavePhoto(base64String: String, fileName: String) {
        guard let selectedView = selectedSquareView,
              let imageData = Data(base64Encoded: base64String),
              let image = UIImage(data: imageData) else { return }

        if let iconButton = selectedView.viewWithTag(100) {
            iconButton.removeFromSuperview()
        }

        let documentGUID = UUID().uuidString
        uploadedPhotos.append(PhotoInfo(fileName: fileName, documentGUID: documentGUID, documentCategory: "Normal", base64String: base64String))

        selectedView.accessibilityIdentifier = documentGUID

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.frame = selectedView.bounds
        imageView.tag = 101
        selectedView.addSubview(imageView)

        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = AppColors.color26
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.tag = 102
        deleteButton.addTarget(self, action: #selector(deletePhoto(_:)), for: .touchUpInside)
        selectedView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: selectedView.topAnchor, constant: 5),
            deleteButton.trailingAnchor.constraint(equalTo: selectedView.trailingAnchor, constant: -5),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    @objc private func deletePhoto(_ sender: UIButton) {
        guard let selectedView = sender.superview else { return }

        selectedView.viewWithTag(101)?.removeFromSuperview()
        sender.removeFromSuperview()

        if let documentGUID = selectedView.accessibilityIdentifier,
           let index = uploadedPhotos.firstIndex(where: { $0.documentGUID == documentGUID }) {
            uploadedPhotos.remove(at: index)
        }

        selectedView.accessibilityIdentifier = nil

        let iconButton = UIButton(type: .system)
        iconButton.setImage(UIImage(systemName: "camera.shutter.button.fill"), for: .normal)
        iconButton.tintColor = AppColors.color2
        iconButton.translatesAutoresizingMaskIntoConstraints = false
        iconButton.tag = 100
        iconButton.addTarget(self, action: #selector(squareViewTapped(_:)), for: .touchUpInside)
        selectedView.addSubview(iconButton)

        NSLayoutConstraint.activate([
            iconButton.centerXAnchor.constraint(equalTo: selectedView.centerXAnchor),
            iconButton.centerYAnchor.constraint(equalTo: selectedView.centerYAnchor)
        ])
    }

    func getUploadedPhotos() -> [PhotoInfo] {
        return uploadedPhotos
    }
}

