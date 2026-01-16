//
//  ManageNotificationsVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit
import UserNotifications

class ManageNotificationsVC: UIViewController {

    let nextButton = UIButton(type: .system)
    let onboardingProgressBarView = OnboardingProgressBarView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let notificationImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = AppColors.color1

       
        onboardingProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        onboardingProgressBarView.setProgress(0.83335)
        onboardingProgressBarView.setBackButtonAction(target: self, action: #selector(backButtonTapped))
        onboardingProgressBarView.setSkipButtonAction(target: self, action: #selector(skipButtonTapped))
        self.view.addSubview(onboardingProgressBarView)

       
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Allow Notifications"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = AppColors.color2
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
       
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "Let us gently remind you to capture your coffee moments. No spam, just like a perfectly brewed cup – smooth and delightful!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = AppColors.color2
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        self.view.addSubview(subtitleLabel)

        notificationImageView.translatesAutoresizingMaskIntoConstraints = false
        notificationImageView.image = UIImage(named: "notification")
        notificationImageView.contentMode = .scaleAspectFit
        
        
        notificationImageView.layer.shadowColor = UIColor.black.cgColor
        notificationImageView.layer.shadowOpacity = 0.7
        notificationImageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        notificationImageView.layer.shadowRadius = 10
        self.view.addSubview(notificationImageView)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = AppColors.color3
        nextButton.setTitleColor(AppColors.color2, for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.layer.cornerRadius = 10
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        self.view.addSubview(nextButton)
        
        let topConstant: CGFloat = (UIScreen.main.bounds.height == 667 || UIScreen.main.bounds.height == 736) ? 60 : 100
        
        let imageSize: CGFloat = (UIScreen.main.bounds.height == 667) ? 260 : 300
        
        NSLayoutConstraint.activate([
        
            onboardingProgressBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
               onboardingProgressBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
               onboardingProgressBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topConstant),
               onboardingProgressBarView.heightAnchor.constraint(equalToConstant: 20),
            
           
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: onboardingProgressBarView.bottomAnchor, constant: 50),
            
           
            subtitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
           
            notificationImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            notificationImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
            notificationImageView.widthAnchor.constraint(equalToConstant: imageSize),
             notificationImageView.heightAnchor.constraint(equalToConstant: imageSize),
            
           
            nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          
         
          NotificationManager.shared.requestNotificationPermission { granted in
              DispatchQueue.main.async {
                  if granted {
                   
                  } else {
                     
                  }
              }
          }
      }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func skipButtonTapped() {
        let notificationSettingsVC = NotificationSettingsVC()
        self.navigationController?.pushViewController(notificationSettingsVC, animated: true)
    }
    
    @objc func nextButtonTapped() {
       
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                   
                    UserProfile.shared.isNotificationEnabled = true
                   
                } else {
                    
                    UserProfile.shared.isNotificationEnabled = false
                    UserProfile.shared.notificationTime = nil
                   
                }
                
                
                
                let notificationSettingsVC = NotificationSettingsVC()
                self.navigationController?.pushViewController(notificationSettingsVC, animated: true)
            }
        }
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
