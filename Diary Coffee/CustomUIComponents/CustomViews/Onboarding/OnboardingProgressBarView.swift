//
//  OnboardingProgressBarView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class OnboardingProgressBarView: UIView {

   
    private let progressContainerView = UIView()
    private let progressView = UIProgressView(progressViewStyle: .default)
    public let backButton = UIButton(type: .system)

    private let skipButton = UIButton(type: .system)

    
    private let darkColor = AppColors.color3
    private let lightColor = AppColors.color2

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    
    private func setupView() {
       
        progressContainerView.translatesAutoresizingMaskIntoConstraints = false
        progressContainerView.backgroundColor = darkColor
        progressContainerView.layer.cornerRadius = 7.5
        progressContainerView.clipsToBounds = true
        self.addSubview(progressContainerView)

       
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = lightColor
        progressView.trackTintColor = .clear
        progressView.progress = 0.0
        progressContainerView.addSubview(progressView)

        
        configureButton(backButton, systemImageName: "chevron.backward")
        configureButton(skipButton, systemImageName: "chevron.forward")

        
        NSLayoutConstraint.activate([
          
            progressContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60),
            progressContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            progressContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            progressContainerView.heightAnchor.constraint(equalToConstant: 15),

            
            progressView.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: progressContainerView.trailingAnchor),
            progressView.centerYAnchor.constraint(equalTo: progressContainerView.centerYAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 15),

            
            backButton.trailingAnchor.constraint(equalTo: progressContainerView.leadingAnchor, constant: -20),
            backButton.centerYAnchor.constraint(equalTo: progressContainerView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            
            skipButton.leadingAnchor.constraint(equalTo: progressContainerView.trailingAnchor, constant: 20),
            skipButton.centerYAnchor.constraint(equalTo: progressContainerView.centerYAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 40),
            skipButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        
        self.bringSubviewToFront(backButton)
        self.bringSubviewToFront(skipButton)
    }

    
    private func configureButton(_ button: UIButton, systemImageName: String) {
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let icon = UIImage(systemName: systemImageName, withConfiguration: iconConfig)
        button.setImage(icon, for: .normal)
        button.tintColor = darkColor
        button.backgroundColor = lightColor
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1.5
        button.layer.borderColor = darkColor.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
    }

   
    func setProgress(_ progress: Float) {
        progressView.setProgress(progress, animated: true)
    }

   
    func setBackButtonHidden(_ hidden: Bool) {
        backButton.isHidden = hidden
    }

    
    func setSkipButtonHidden(_ hidden: Bool) {
        skipButton.isHidden = hidden
    }

    
    func setBackButtonAction(target: Any, action: Selector) {
        backButton.addTarget(target, action: action, for: .touchUpInside)
    }

    
    func setSkipButtonAction(target: Any, action: Selector) {
        skipButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
