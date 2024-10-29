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
    let onboardingProgressBarView = OnboardingProgressBarView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let reminderView = ReminderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)

        reminderView.reminderPickerView.onTimeSelected = { [weak self] selectedTime in
               self?.reminderView.updateTimeButtonTitle(with: selectedTime) // Seçilen zamanı timeButton'a ayarla
               self?.dismissOverlay() // Zaman seçildiğinde bulanık görünümü kapat
           }
        
        onboardingProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        onboardingProgressBarView.setProgress(0.625)
        onboardingProgressBarView.setBackButtonAction(target: self, action: #selector(backButtonTapped))
        onboardingProgressBarView.setSkipButtonHidden(true) // Skip butonunu gizliyoruz
        self.view.addSubview(onboardingProgressBarView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Never miss a coffee moment!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "We’ll send you a little reminder each day at your chosen time, so you can savor every sip."
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        self.view.addSubview(subtitleLabel)

        reminderView.translatesAutoresizingMaskIntoConstraints = false
        reminderView.timeButton.addTarget(self, action: #selector(timeButtonTapped), for: .touchUpInside)
        self.view.addSubview(reminderView)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        startButton.setTitleColor(UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0), for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        startButton.layer.cornerRadius = 10
        self.view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            onboardingProgressBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            onboardingProgressBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            onboardingProgressBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
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
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
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
}

