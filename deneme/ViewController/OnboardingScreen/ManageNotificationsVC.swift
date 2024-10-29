//
//  ManageNotificationsVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class ManageNotificationsVC: UIViewController {

    let nextButton = UIButton(type: .system)
    let onboardingProgressBarView = OnboardingProgressBarView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let notificationImageView = UIImageView() // Bildirim resmi için UIImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)

        // Progress Bar
        onboardingProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        onboardingProgressBarView.setProgress(0.5)
        onboardingProgressBarView.setBackButtonAction(target: self, action: #selector(backButtonTapped))
        onboardingProgressBarView.setSkipButtonAction(target: self, action: #selector(skipButtonTapped))
        self.view.addSubview(onboardingProgressBarView)

        // Main Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Allow Notifications"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "Let us gently remind you to capture your coffee moments. No spam, just like a perfectly brewed cup – smooth and delightful!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        self.view.addSubview(subtitleLabel)

        // Notification Image
        notificationImageView.translatesAutoresizingMaskIntoConstraints = false
        notificationImageView.image = UIImage(named: "notification") // Asset dosyasındaki "notification" resmini kullanıyoruz.
        notificationImageView.contentMode = .scaleAspectFit
        
        // Gölge eklemek için
        notificationImageView.layer.shadowColor = UIColor.black.cgColor
        notificationImageView.layer.shadowOpacity = 0.7
        notificationImageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        notificationImageView.layer.shadowRadius = 10
        self.view.addSubview(notificationImageView)
        
        // Next Button
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        nextButton.setTitleColor(UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0), for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.layer.cornerRadius = 10
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        self.view.addSubview(nextButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            // OnboardingProgressBarView Constraints
            onboardingProgressBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            onboardingProgressBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            onboardingProgressBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            onboardingProgressBarView.heightAnchor.constraint(equalToConstant: 20),
            
            // Title Label Constraints - Üstte olacak
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: onboardingProgressBarView.bottomAnchor, constant: 50),
            
            // Subtitle Label Constraints - Üstte olacak
            subtitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            // Notification ImageView Constraints - Altta ve daha büyük
            notificationImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            notificationImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
            notificationImageView.widthAnchor.constraint(equalToConstant: 300), // Daha büyük genişlik
            notificationImageView.heightAnchor.constraint(equalToConstant: 300), // Daha büyük yükseklik
            
            // Next Button Constraints
            nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func skipButtonTapped() {
        let notificationSettingsVC = NotificationSettingsVC()
        self.navigationController?.pushViewController(notificationSettingsVC, animated: true)
    }
    
    @objc func nextButtonTapped() {
      
        let notificationSettingsVC = NotificationSettingsVC()
        self.navigationController?.pushViewController(notificationSettingsVC, animated: true)
    }

}
