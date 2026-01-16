//
//  StickerView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 30.10.2024.
//

import UIKit

class StickerView: UIView {
    
    private var overlayView: UIView?
    private var stickerSelectorView: StickerSelectorView?
    private var selectedCircleView: UIView?
    private var selectedStickers: [(fileName: String, documentGUID: String, base64String: String)] = []
    var hasStickers: Bool {
           return !selectedStickers.isEmpty
       }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.backgroundColor = AppColors.color26
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
      
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("coffee_moments_in_stickers", comment: "")
        titleLabel.textColor = AppColors.color2
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 250)
        ])
        
       
        let circleSize: CGFloat = 90
        let circleColor = AppColors.color20
        let iconColor = AppColors.color2
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        for _ in 0..<3 {
            let circleView = UIView()
            circleView.backgroundColor = circleColor
            circleView.layer.cornerRadius = circleSize / 2
            circleView.translatesAutoresizingMaskIntoConstraints = false
            circleView.widthAnchor.constraint(equalToConstant: circleSize).isActive = true
            circleView.heightAnchor.constraint(equalToConstant: circleSize).isActive = true
            
            let iconButton = UIButton(type: .system)
            iconButton.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
            iconButton.tintColor = iconColor
            iconButton.translatesAutoresizingMaskIntoConstraints = false
            iconButton.addTarget(self, action: #selector(circleTapped(_:)), for: .touchUpInside)
            circleView.addSubview(iconButton)
            
            let stickerImageView = UIImageView()
            stickerImageView.contentMode = .scaleAspectFit
            stickerImageView.isHidden = true
            stickerImageView.translatesAutoresizingMaskIntoConstraints = false
            circleView.addSubview(stickerImageView)
            
            let removeButton = UIButton(type: .system)
            removeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            removeButton.tintColor =  AppColors.color2
            removeButton.backgroundColor = circleColor
            removeButton.layer.cornerRadius = 12
            removeButton.clipsToBounds = true
            removeButton.translatesAutoresizingMaskIntoConstraints = false
            removeButton.isHidden = true
            removeButton.addTarget(self, action: #selector(removeSticker), for: .touchUpInside)
            circleView.addSubview(removeButton)
            
            NSLayoutConstraint.activate([
                iconButton.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
                iconButton.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
                
                stickerImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
                stickerImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
                stickerImageView.widthAnchor.constraint(equalTo: circleView.widthAnchor, multiplier: 0.6),
                stickerImageView.heightAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 0.6),
                
                removeButton.topAnchor.constraint(equalTo: circleView.topAnchor, constant: 4),
                removeButton.trailingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: -4),
                removeButton.widthAnchor.constraint(equalToConstant: 24),
                removeButton.heightAnchor.constraint(equalToConstant: 24)
            ])
            
            circleView.accessibilityElements = [iconButton, stickerImageView, removeButton]
            stackView.addArrangedSubview(circleView)
        }
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 20)
        ])
    }

    @objc private func circleTapped(_ sender: UIButton) {
        guard let circleView = sender.superview else { return }
        selectedCircleView = circleView
        showStickerSelectorView()
    }
    
    private func showStickerSelectorView() {
        guard let parentVC = self.parentViewController else { return }

           
           guard let stickers = (parentVC as? DiaryEntryVC)?.userProfileInformation?.userProfileInfo?.purchasedFeatures?.stickers,
                 !stickers.isEmpty else {
              
               showNoStickersAlert(in: parentVC)
               return
           }
        
        let stickerCategories = stickers.map { $0.category }
        
        overlayView = UIView(frame: parentVC.view.bounds)
        overlayView?.translatesAutoresizingMaskIntoConstraints = false
        overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        parentVC.view.addSubview(overlayView!)
        
      
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideStickerSelectorView))
        overlayView?.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            overlayView!.topAnchor.constraint(equalTo: parentVC.view.topAnchor),
            overlayView!.bottomAnchor.constraint(equalTo: parentVC.view.bottomAnchor),
            overlayView!.leadingAnchor.constraint(equalTo: parentVC.view.leadingAnchor),
            overlayView!.trailingAnchor.constraint(equalTo: parentVC.view.trailingAnchor)
        ])
        
        stickerSelectorView = StickerSelectorView()
        stickerSelectorView?.translatesAutoresizingMaskIntoConstraints = false
        parentVC.view.addSubview(stickerSelectorView!)
        
        self.stickerSelectorView?.setPurchasedStickers(stickerCategories)
        
        stickerSelectorView?.onStickerSelected = { [weak self] selectedImage in
            self?.addStickerToCircle(selectedImage)
            self?.hideStickerSelectorView()
        }
        
        NSLayoutConstraint.activate([
            stickerSelectorView!.leadingAnchor.constraint(equalTo: parentVC.view.leadingAnchor),
            stickerSelectorView!.trailingAnchor.constraint(equalTo: parentVC.view.trailingAnchor),
            stickerSelectorView!.heightAnchor.constraint(equalToConstant: 300),
            stickerSelectorView!.topAnchor.constraint(equalTo: parentVC.view.bottomAnchor)
        ])
        
        parentVC.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.stickerSelectorView?.transform = CGAffineTransform(translationX: 0, y: -300)
            self.overlayView?.alpha = 1
        }
    }
    
    
    private func showNoStickersAlert(in parentVC: UIViewController) {
        let alertView = MainAlertView(frame: parentVC.view.bounds)
        alertView.configure(
            title: NSLocalizedString("no_stickers_available", comment: ""),
            message: NSLocalizedString("no_stickers_message", comment: ""),
            cancelAction: { [weak alertView] in
                alertView?.removeFromSuperview()
            },
            actionButtonTitle: NSLocalizedString("ok", comment: ""),
            actionHandler: { [weak alertView] in
                alertView?.removeFromSuperview()
                
               
                if let customTabBarController = UIApplication.shared.windows.first?.rootViewController as? CustomTabBarController {
                   
                    customTabBarController.selectedIndex = 2
                }
                
               
                parentVC.dismiss(animated: true)
            }
        )
        parentVC.view.addSubview(alertView)
    }

        
    @objc private func hideStickerSelectorView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.stickerSelectorView?.transform = .identity
            self.overlayView?.alpha = 0
        }) { _ in
            self.stickerSelectorView?.removeFromSuperview()
            self.overlayView?.removeFromSuperview()
        }
    }

    
    
    func createFilePath(_ fileName: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent(fileName)
    }

    func getSelectedStickers() -> [[String: String]] {
        return selectedStickers.map { sticker in
            return [
                "FileName": sticker.fileName,
                "DocumentGUID": sticker.documentGUID,
                "DocumentCategory": "Sticker",
                "base64Data": sticker.base64String
            ]
        }
    }
    
    
    private func addStickerToCircle(_ sticker: UIImage) {
        guard let circleView = selectedCircleView,
              let elements = circleView.accessibilityElements as? [UIView],
              elements.count == 3,
              let iconButton = elements[0] as? UIButton,
              let stickerImageView = elements[1] as? UIImageView,
              let removeButton = elements[2] as? UIButton else { return }

      
        stickerImageView.image = sticker
        stickerImageView.isHidden = false
        iconButton.isHidden = true
        removeButton.isHidden = false

       
        guard let jpegData = sticker.jpegData(compressionQuality: 0.8) else {
           
            return
        }

        let base64String = jpegData.base64EncodedString()
        let documentGUID = UUID().uuidString
        let fileName = "\(documentGUID).jpg"
        
      
        circleView.accessibilityIdentifier = documentGUID

        selectedStickers.append((fileName: fileName, documentGUID: documentGUID, base64String: base64String))
    }

    @objc private func removeSticker(_ sender: UIButton) {
        guard let circleView = sender.superview,
              let elements = circleView.accessibilityElements as? [UIView],
              elements.count == 3,
              let iconButton = elements[0] as? UIButton,
              let stickerImageView = elements[1] as? UIImageView else { return }
        
        
        stickerImageView.isHidden = true
        iconButton.isHidden = false
        sender.isHidden = true

       
        if let documentGUID = circleView.accessibilityIdentifier,
           let index = selectedStickers.firstIndex(where: { $0.documentGUID == documentGUID }) {
            selectedStickers.remove(at: index)
        }
        
      
        circleView.accessibilityIdentifier = nil
    }


}

