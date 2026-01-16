//
//  OnboardingIntroVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class OnboardingIntroVC: UIViewController {

    let onboardingProgressBarView = OnboardingProgressBarView()
    var uiElements: [UIView] = []
    var nextButton: UIButton!

    
    let onboardingContainerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = AppColors.color3
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
            return view
        }()
        
        let onboardingImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.alpha = 0
            return imageView
        }()
    
    let onboardingImages = (1...11).map { "Onboarding\($0)" }
    
    lazy var transformScales: [(CGFloat, CGFloat)] = {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.nativeBounds.height
        let isIphone8 = (screenWidth == 375.0 && screenHeight == 1334.0)
        let isIphone8Plus = (screenWidth == 414.0 && screenHeight == 2208.0)
        let isIphone14 = (screenWidth == 390.0)
        let isIphone14Plus = (screenWidth == 428.0)
        let isIphone14Pro = (screenWidth == 393.0)
        let isIphone15Pro = (screenWidth == 393.0)
        let isIphone15ProMax = (screenWidth == 430.0)
        let isIphone11OrXR = (screenWidth == 414.0 && screenHeight == 1792.0)
        let isIphone11Pro = (screenWidth == 375.0)
        let isIphone11ProMax = (screenWidth == 414.0 && screenHeight == 2688.0)

        return [
            isIphone8 ? (1.05, 1.05) : (isIphone14Plus ? (1.8, 1.8) : (isIphone15ProMax ? (1.9, 1.9) : (isIphone11ProMax ? (1.8, 1.8) : (isIphone11Pro ? (1.5, 1.5) : (isIphone11OrXR ? (1.12, 1.12) : (1.7, 1.7)))))),
            
            isIphone8 ? (0.78, 0.78) : (isIphone8Plus ? (1.4, 1.4) : (isIphone14 ? (1.4, 1.4) : (isIphone14Plus ? (1.65, 1.65) : (isIphone15ProMax ? (1.8, 1.8) : (isIphone11ProMax ? (1.7, 1.7) : (isIphone11Pro ? (1.3, 1.3) : (isIphone11OrXR ? (1.05, 1.05) : (1.5, 1.5)))))))),
            
            isIphone8 ? (0.37, 0.27) : (isIphone8Plus ? (0.4, 0.3) : (isIphone14 ? (0.43, 0.33) : (isIphone14Plus ? (0.50, 0.40) : (isIphone15ProMax ? (0.5, 0.4) : (isIphone11Pro ? (0.40, 0.3) : (0.45, 0.35)))))),
            
            isIphone8 ? (0.37, 0.37) : (isIphone8Plus ? (0.42, 0.42) : (isIphone14 ? (0.45, 0.45) : (isIphone14Plus ? (0.55, 0.55) : (isIphone14Pro ? (0.45, 0.45) : (isIphone15ProMax ? (0.55, 0.55) : (isIphone11Pro ? (0.42, 0.42) : (0.5, 0.5))))))),
            
            isIphone8 ? (0.48, 0.48) : (isIphone8Plus ? (0.55, 0.55) : isIphone14Plus ? (0.55, 0.55) : (isIphone15ProMax ? (0.6, 0.6) : (isIphone11OrXR ? (0.55, 0.55) : (isIphone11ProMax ? (0.55, 0.55) : (0.5, 0.5))))),
            
            isIphone8 ? (0.90, 0.90) : (isIphone8Plus ? (1.6, 1.6) : isIphone14Plus ? (1.7, 1.7) : (isIphone15ProMax ? (1.7, 1.7) : (isIphone11ProMax ? (1.6, 1.6) : (isIphone11OrXR ? (1.05, 1.05) : (1.5, 1.5))))),
            
            isIphone8 ? (0.35, 0.35) : (isIphone8Plus ? (0.42, 0.42) : (isIphone14 ? (0.45, 0.45) : (isIphone14Pro ? (0.45, 0.45) : (isIphone15ProMax ? (0.53, 0.53) : (isIphone11Pro ? (0.42, 0.42) : (0.5, 0.5)))))),
            
            isIphone8 ? (0.43, 0.43) : (isIphone14Plus ? (0.55, 0.55) : (isIphone15ProMax ? (0.55, 0.55) : (0.5, 0.5))),
            
            isIphone8 ? (0.47, 0.47) : (isIphone14 ? (0.5, 0.5) : (isIphone14Pro ? (0.5, 0.5) : (isIphone15Pro ? (0.6, 0.6) : (isIphone11Pro ? (0.5, 0.5) : (0.55, 0.55))))),
            
            isIphone8 ? (0.47, 0.47) : (isIphone14 ? (0.5, 0.5) : (isIphone14Pro ? (0.5, 0.5) : (isIphone15Pro ? (0.62, 0.62) : (isIphone11Pro ? (0.5, 0.5) : (0.55, 0.55))))),
            
            isIphone8 ? (0.45, 0.45) : (isIphone14 ? (0.5, 0.5) : (isIphone14Pro ? (0.5, 0.5) : (isIphone15Pro ? (0.65, 0.65) : (isIphone11Pro ? (0.5, 0.5) : (0.55, 0.55)))))
        ]
    }()


       var currentImageIndex = 0
       var containerWidthConstraint: NSLayoutConstraint!
       var containerHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true

        self.view.backgroundColor = AppColors.color1


        onboardingProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(onboardingProgressBarView)

    
        onboardingProgressBarView.setBackButtonHidden(true)
        onboardingProgressBarView.setSkipButtonHidden(true)

        onboardingProgressBarView.setProgress(0.16667)


        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Brewing Memories, One Sip at a Time"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = AppColors.color2
        titleLabel.textAlignment = .center

        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "With Diary Coffee, jot down your day’s moments with just a few taps!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = AppColors.color2
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        nextButton = UIButton(type: .system)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = AppColors.color3
        nextButton.setTitleColor(AppColors.color2, for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.layer.cornerRadius = 10

        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        let updatedTermsLabel = UILabel()
        updatedTermsLabel.translatesAutoresizingMaskIntoConstraints = false
        updatedTermsLabel.text = "*Updated Terms of Use effective from October"
        updatedTermsLabel.font = UIFont.boldSystemFont(ofSize: 13)
        updatedTermsLabel.textColor = AppColors.color4
        updatedTermsLabel.textAlignment = .center
        updatedTermsLabel.attributedText = NSAttributedString(
            string: updatedTermsLabel.text!,
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )

        let agreementLabel = UILabel()
        agreementLabel.translatesAutoresizingMaskIntoConstraints = false
        agreementLabel.text = "By pressing [Next], you agree to the Terms of Service and Privacy Policy."
        agreementLabel.font = UIFont.boldSystemFont(ofSize: 13)
        agreementLabel.textColor = AppColors.color4
        agreementLabel.textAlignment = .center
        agreementLabel.numberOfLines = 0


        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(nextButton)
        self.view.addSubview(agreementLabel)
        self.view.addSubview(updatedTermsLabel)
        self.view.addSubview(onboardingContainerView)
        onboardingContainerView.addSubview(onboardingImageView)
        uiElements = [titleLabel, subtitleLabel, nextButton, updatedTermsLabel, agreementLabel]


        let initialScale = transformScales[currentImageIndex]
           let baseSize: CGFloat = 150
           let containerSize = CGSize(width: (initialScale.0 + 0.5) * baseSize,
                                      height: (initialScale.1 + 0.5) * baseSize)

           containerWidthConstraint = onboardingContainerView.widthAnchor.constraint(equalToConstant: containerSize.width)
           containerHeightConstraint = onboardingContainerView.heightAnchor.constraint(equalToConstant: containerSize.height)
        
        
        var centerYOffset: CGFloat = 0
        
        switch currentImageIndex {
        case 0:
            centerYOffset = 0
        case 1:
            centerYOffset = 30
        default:
            centerYOffset = 35
        }
        
        let screenWidth = UIScreen.main.bounds.width

      
        var sidePadding: CGFloat = 40
        if screenWidth == 390 {
            sidePadding = 30
        }
      
        else if screenWidth == 375 {
            sidePadding = 20
        }

        
        let topConstant: CGFloat = (UIScreen.main.bounds.height == 667 || UIScreen.main.bounds.height == 736) ? 60 : 100
        
        let isIphone8 = (UIScreen.main.bounds.width == 375.0 && UIScreen.main.nativeBounds.height == 1334.0)
        let topSpacing: CGFloat = isIphone8 ? 30 : 50
        
        NSLayoutConstraint.activate([
        
            onboardingProgressBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
               onboardingProgressBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
               onboardingProgressBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topConstant),
               onboardingProgressBarView.heightAnchor.constraint(equalToConstant: 20),


           
            titleLabel.topAnchor.constraint(equalTo: onboardingProgressBarView.bottomAnchor, constant: topSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: sidePadding),
               titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -sidePadding),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),

            agreementLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            agreementLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            agreementLabel.bottomAnchor.constraint(equalTo: updatedTermsLabel.topAnchor, constant: -5),

            updatedTermsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            updatedTermsLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            updatedTermsLabel.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),

            nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
            onboardingContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
               onboardingContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: centerYOffset),
               
               containerWidthConstraint,
               containerHeightConstraint,

               onboardingImageView.centerXAnchor.constraint(equalTo: onboardingContainerView.centerXAnchor),
               onboardingImageView.centerYAnchor.constraint(equalTo: onboardingContainerView.centerYAnchor)
                   ])
                   
                   showNextOnboardingImage()
               }

    func showNextOnboardingImage() {
        let nextImage = UIImage(named: onboardingImages[currentImageIndex])
        onboardingImageView.image = nextImage
        onboardingImageView.alpha = 0

        guard let imageSize = nextImage?.size else { return }

        let (scaleX, scaleY) = transformScales[currentImageIndex]
        onboardingImageView.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)

        let isIphone8 = (UIScreen.main.bounds.width == 375.0 && UIScreen.main.nativeBounds.height == 1334.0)

      
        let yOffsetAdjustment: CGFloat
        if isIphone8 {
            
                yOffsetAdjustment = -10
           
        } else {
            yOffsetAdjustment = 0
        }

        let (newContainerWidth, newContainerHeight, centerYOffset): (CGFloat, CGFloat, CGFloat)

        switch currentImageIndex {
        case 0:
            newContainerWidth = imageSize.width * (scaleX + 0.13)
            newContainerHeight = imageSize.height * (scaleY + 0.35)
            centerYOffset = 0 + yOffsetAdjustment
        case 1:
            newContainerWidth = imageSize.width * (scaleX + 0.13)
            newContainerHeight = imageSize.height * (scaleY + 0.11)
            centerYOffset = 30 + yOffsetAdjustment
        case 2, 3:
            newContainerWidth = imageSize.width * (scaleX + 0.03)
            newContainerHeight = imageSize.height * (scaleY + 0.02)
            centerYOffset = 35 + yOffsetAdjustment
        case 4:
            newContainerWidth = imageSize.width * (scaleX + 0.05)
            newContainerHeight = imageSize.height * (scaleY + 0.07)
            centerYOffset = 35 + yOffsetAdjustment
        case 5:
            newContainerWidth = imageSize.width * (scaleX + 0.15)
            newContainerHeight = imageSize.height * (scaleY + 0.17)
            centerYOffset = 35 + yOffsetAdjustment
        case 6:
            newContainerWidth = imageSize.width * (scaleX + 0.05)
            newContainerHeight = imageSize.height * (scaleY + 0.05)
            centerYOffset = 35 + yOffsetAdjustment
        default:
            newContainerWidth = imageSize.width * (scaleX + 0.05)
            newContainerHeight = imageSize.height * (scaleY + 0.05)
            centerYOffset = 35 + yOffsetAdjustment
        }

      
        self.containerWidthConstraint.constant = newContainerWidth
        self.view.layoutIfNeeded()

    
        for constraint in self.view.constraints {
            if constraint.firstItem === onboardingContainerView && constraint.firstAttribute == .centerY {
                self.view.removeConstraint(constraint)
                break
            }
        }

      
        let newCenterYConstraint = onboardingContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: centerYOffset)
        newCenterYConstraint.isActive = true


        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: [.curveEaseInOut], animations: {
            self.containerHeightConstraint.constant = newContainerHeight
            self.view.layoutIfNeeded()
        }) { _ in
            UIView.animate(withDuration: 1.0, delay: 0.2, options: [.curveEaseOut], animations: {
                self.onboardingImageView.alpha = 1
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
                        self.onboardingImageView.alpha = 0
                    }) { _ in
                        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: [.curveEaseInOut], animations: {
                            self.containerHeightConstraint.constant = 0
                            self.view.layoutIfNeeded()
                        }) { _ in
                            self.currentImageIndex += 1
                            if self.currentImageIndex >= self.onboardingImages.count {
                                self.currentImageIndex = 0
                            }
                            self.showNextOnboardingImage()
                        }
                    }
                }
            }
        }
    }

    @objc func nextButtonTapped() {
        let genderSelectionVC = GenderSelectionVC()
        self.navigationController?.pushViewController(genderSelectionVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? CustomTabBarController {
          
            tabBarController.tabBar.isHidden = true
            tabBarController.tabBar.isUserInteractionEnabled = false
            tabBarController.tabBar.items?.forEach { $0.isEnabled = false }

           
            tabBarController.circularView.isHidden = true
            tabBarController.circularView.isUserInteractionEnabled = false
            
          
            if let gestures = tabBarController.circularView.gestureRecognizers {
                gestures.forEach { tabBarController.circularView.removeGestureRecognizer($0) }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            
            tabBarController.tabBar.isHidden = false
            tabBarController.tabBar.isUserInteractionEnabled = true
            tabBarController.tabBar.items?.forEach { $0.isEnabled = true }

            
            tabBarController.circularView.isHidden = false
            tabBarController.circularView.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: tabBarController, action: #selector(tabBarController.circularViewTapped))
            tabBarController.circularView.addGestureRecognizer(tapGesture)
        }
    }
}

extension UIDevice {
    var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)), encoding: .utf8)?.trimmingCharacters(in: .controlCharacters) ?? "unknown"
    }
}
