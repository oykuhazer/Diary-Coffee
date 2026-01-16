//
//  SecurityViewController.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 5.10.2024.
//

import UIKit

protocol KeyboardContainerViewDelegate: AnyObject {
    func didTapNumberButton(_ number: String)
    func didTapDeleteButton()
}

import UIKit

class PinCodeLoginVC: UIViewController, KeyboardContainerViewDelegate {
    private let containerView = PinContainerView()
    private let keyboardContainerView = KeyboardContainerView()
    private var currentPinIndex = 0
    var isFromSettings: Bool = false
    var isFromOnboarding: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.color1

        if isFromSettings || isFromOnboarding {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        navigationController?.navigationBar.tintColor = AppColors.color3
        }
        
        keyboardContainerView.delegate = self
        
        setupUI()
       
    }
    
    private func setupUI() {
        view.addSubview(containerView)
        view.addSubview(keyboardContainerView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let horizontalPadding: CGFloat = screenWidth <= 375 ? 20 : 30
        var topPadding: CGFloat = screenWidth <= 375 ? 20 : 30
        var keyboardTopPadding: CGFloat = 50

       
        if screenWidth == 375 && screenHeight == 667 {
            topPadding = 0
            keyboardTopPadding = 20 
        }

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            
            keyboardContainerView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: keyboardTopPadding),
            keyboardContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            keyboardContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding)
        ])
    }



   
    func didTapNumberButton(_ number: String) {
        addPinDigit(number)
    }
    
    func didTapDeleteButton() {
        deleteLastPinDigit()
    }
    
    private func addPinDigit(_ digit: String) {
        if currentPinIndex < containerView.pinTextFields.count {
            let currentField = containerView.pinTextFields[currentPinIndex]
            currentField.text = digit
            animatePinField(currentField)
            currentPinIndex += 1
        }
    }
    
    private func animatePinField(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            textField.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            textField.backgroundColor = AppColors.color1
            textField.textColor = AppColors.color2
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                textField.transform = CGAffineTransform.identity
            }
        }
    }
    
    private func deleteLastPinDigit() {
        if currentPinIndex > 0 {
            currentPinIndex -= 1
         
            let currentField = containerView.pinTextFields[currentPinIndex]
            currentField.text = ""
            UIView.animate(withDuration: 0.3) {
                currentField.backgroundColor = AppColors.color4
                currentField.textColor = AppColors.color2
            }
        }
    }
   
    @objc func setPinButtonTapped() {
        let enteredPinCode = containerView.pinTextFields.compactMap { $0.text }.joined()

        guard enteredPinCode.count == containerView.pinTextFields.count else {
            return
        }

        let userProfile = UserProfile.shared

        if !isFromSettings && !isFromOnboarding {
            if enteredPinCode == userProfile.passcodeCode {
                self.dismiss(animated: true, completion: nil)
            } else {
                shakeScreen()
            }
        } else {
            userProfile.passcodeCode = enteredPinCode
            userProfile.isPasscodeEnabled = true

            userProfile.styleSelection = "ClassicSet1"

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"

            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"

            let birthDateString = userProfile.birthDate != nil ? dateFormatter.string(from: userProfile.birthDate!) : "N/A"
            let notificationTimeString = userProfile.notificationTime != nil ? timeFormatter.string(from: userProfile.notificationTime!) : "N/A"

            let purchasedFeatures = PurchasedFeatures(
                stickers: userProfile.purchasedStickers,
                emotions: userProfile.purchasedEmotions
            )
            
            let query = SaveUserProfileQuery(
                uuid: userProfile.uuid,
                gender: userProfile.gender ?? "N/A",
                name: userProfile.name ?? "N/A",
                birthDate: birthDateString,
                styleSelection: userProfile.styleSelection ?? "N/A",
                isNotificationEnabled: userProfile.isNotificationEnabled,
                notificationTime: notificationTimeString,
                isPasscodeEnabled: userProfile.isPasscodeEnabled,
                passcodeType: userProfile.passcodeType ?? "N/A",
                passcodeCode: userProfile.passcodeCode ?? "N/A",
                language: userProfile.language ?? "English",
                quantityBeans: userProfile.quantityBeans ?? 0,
                profilePicture: userProfile.profilePicture ?? "N/A",
                purchasedFeatures: purchasedFeatures,
                premium: userProfile.premium,
                premiumType: userProfile.premiumType ?? "N/A",
                premiumStartDate: userProfile.premiumStartDate?.description ?? "N/A",
                premiumDaysLeft: userProfile.premiumDaysLeft ?? 0
            )

            SaveUserProfileRequest.shared.saveUserProfile(in: self.view) { result in
                switch result {
                case .success(_):
                    if self.isFromSettings {
                        let settingVC = SettingsVC()
                        settingVC.shouldShowSuccessMessage2 = true
                        self.navigationController?.pushViewController(settingVC, animated: true)
                    } else {
                        let customTabBarController = CustomTabBarController()
                        customTabBarController.selectedIndex = 0
                        customTabBarController.modalPresentationStyle = .fullScreen
                        self.present(customTabBarController, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print("")
                }
            }

        }
    }


    private func shakeScreen() {
           let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
           animation.timingFunction = CAMediaTimingFunction(name: .linear)
           animation.duration = 0.5
           animation.values = [-10, 10, -10, 10, -5, 5, -2, 2, 0]
           view.layer.add(animation, forKey: "shake")
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
