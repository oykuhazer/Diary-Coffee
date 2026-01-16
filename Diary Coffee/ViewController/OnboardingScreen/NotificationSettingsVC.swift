//
//  NotificationSettingsVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class NotificationSettingsVC: UIViewController {
    
    var overlayView: UIView?
    let startButton = UIButton(type: .system)
    let loginButton = UIButton(type: .system)
    let onboardingProgressBarView = OnboardingProgressBarView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let reminderView = ReminderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = AppColors.color1

        reminderView.reminderPickerView.onTimeSelected = { [weak self] selectedTime in
               self?.reminderView.updateTimeButtonTitle(with: selectedTime)
               self?.dismissOverlay()
           }
        
        onboardingProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        onboardingProgressBarView.setProgress(1)
        onboardingProgressBarView.setBackButtonAction(target: self, action: #selector(backButtonTapped))
        onboardingProgressBarView.setSkipButtonHidden(true)
        self.view.addSubview(onboardingProgressBarView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Never miss a coffee moment!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = AppColors.color2
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "We’ll send you a little reminder each day at your chosen time, so you can savor every sip."
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = AppColors.color2
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        self.view.addSubview(subtitleLabel)

        reminderView.translatesAutoresizingMaskIntoConstraints = false
        reminderView.timeButton.addTarget(self, action: #selector(timeButtonTapped), for: .touchUpInside)
        self.view.addSubview(reminderView)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = AppColors.color3
        startButton.setTitleColor(AppColors.color2, for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        startButton.layer.cornerRadius = 10
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        self.view.addSubview(startButton)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Set Up Passcode", for: .normal)
        loginButton.backgroundColor = AppColors.color1
        loginButton.setTitleColor(AppColors.color2, for: .normal)
        loginButton.layer.borderColor = AppColors.color4.cgColor
        loginButton.layer.borderWidth = 2
        loginButton.layer.cornerRadius = 10
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        self.view.addSubview(loginButton)

        let topConstant: CGFloat = (UIScreen.main.bounds.height == 667 || UIScreen.main.bounds.height == 736) ? 60 : 100
        
        NSLayoutConstraint.activate([
        
            onboardingProgressBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
               onboardingProgressBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
               onboardingProgressBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topConstant),
               onboardingProgressBarView.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: onboardingProgressBarView.bottomAnchor, constant: 50),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            reminderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            reminderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            reminderView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            reminderView.heightAnchor.constraint(equalToConstant: 80),
            
            startButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            loginButton.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func loginButtonTapped() {
        
        
        if UserProfile.shared.isNotificationEnabled {
           
            if let timeString = reminderView.timeButton.title(for: .normal), timeString != "Set Time" {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                if let timeDate = formatter.date(from: timeString) {
                    UserProfile.shared.notificationTime = timeDate
                }
            }
        } else {
           
            UserProfile.shared.notificationTime = nil
        }
        
     
        let formattedTime = UserProfile.shared.notificationTime != nil ? reminderView.timeButton.title(for: .normal) ?? "N/A" : "N/A"
        
        let pinCodeLoginVC = PinCodeLoginVC()
        pinCodeLoginVC.isFromOnboarding = true
        self.navigationController?.pushViewController(pinCodeLoginVC, animated: true)
    }
    
    @objc func startButtonTapped() {
        if UserProfile.shared.isNotificationEnabled {
            if let timeString = reminderView.timeButton.title(for: .normal), timeString != "Set Time" {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                if let timeDate = formatter.date(from: timeString) {
                    UserProfile.shared.notificationTime = timeDate
                }
            }
        } else {
            UserProfile.shared.notificationTime = nil
        }

        let notificationTimeFormatted = UserProfile.shared.notificationTime != nil ? reminderView.timeButton.title(for: .normal) ?? "N/A" : "N/A"

        UserProfile.shared.isPasscodeEnabled = false
        UserProfile.shared.passcodeCode = "N/A"

        let birthDateFormatted: String = {
            if let date = UserProfile.shared.birthDate {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return formatter.string(from: date)
            } else {
                return "N/A"
            }
        }()

        let userProfile = UserProfile.shared

        userProfile.styleSelection = "ClassicSet1"

        let purchasedFeatures = PurchasedFeatures(
            stickers: userProfile.purchasedStickers,
            emotions: userProfile.purchasedEmotions
        )
        
        let query = SaveUserProfileQuery(
            uuid: userProfile.uuid,
            gender: userProfile.gender ?? "N/A",
            name: userProfile.name ?? "N/A",
            birthDate: birthDateFormatted,
            styleSelection: userProfile.styleSelection ?? "N/A",
            isNotificationEnabled: userProfile.isNotificationEnabled,
            notificationTime: notificationTimeFormatted,
            isPasscodeEnabled: userProfile.isNotificationEnabled == false,
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
                let customTabBarController = CustomTabBarController()
                customTabBarController.selectedIndex = 0
                customTabBarController.modalPresentationStyle = .fullScreen
                self.present(customTabBarController, animated: true, completion: nil)

            case .failure(let error): break
            }
        }
    }

    
    @objc private func timeButtonTapped() {
        reminderView.reminderPickerView.showOverlayWithBlurEffect(on: self.view)
    }

    @objc public func dismissOverlay() {
     
        reminderView.reminderPickerView.isHidden = true
        overlayView?.removeFromSuperview()
        overlayView = nil                               
    }

    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
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


