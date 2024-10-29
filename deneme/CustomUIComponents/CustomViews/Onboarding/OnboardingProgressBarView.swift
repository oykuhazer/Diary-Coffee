//
//  OnboardingProgressBarView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class OnboardingProgressBarView: UIView {

    // Progress bar, back and skip buttons
    private let progressContainerView = UIView()
    private let progressView = UIProgressView(progressViewStyle: .default)
    public let backButton = UIButton(type: .system)

    private let skipButton = UIButton(type: .system)

    // Colors
    private let darkColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
    private let lightColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // Set up views inside the progress bar view
    private func setupView() {
        // Progress Container View
        progressContainerView.translatesAutoresizingMaskIntoConstraints = false
        progressContainerView.backgroundColor = darkColor
        progressContainerView.layer.cornerRadius = 7.5
        progressContainerView.clipsToBounds = true
        self.addSubview(progressContainerView)

        // Progress View
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = lightColor
        progressView.trackTintColor = .clear
        progressView.progress = 0.0
        progressContainerView.addSubview(progressView)

        // Configure buttons
        configureButton(backButton, systemImageName: "chevron.backward")
        configureButton(skipButton, systemImageName: "chevron.forward")

        // Layout Constraints
        NSLayoutConstraint.activate([
            // ProgressContainerView Constraints
            progressContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60),
            progressContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            progressContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            progressContainerView.heightAnchor.constraint(equalToConstant: 15),

            // ProgressView Constraints
            progressView.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: progressContainerView.trailingAnchor),
            progressView.centerYAnchor.constraint(equalTo: progressContainerView.centerYAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 15),

            // Back Button Constraints
            backButton.trailingAnchor.constraint(equalTo: progressContainerView.leadingAnchor, constant: -20),
            backButton.centerYAnchor.constraint(equalTo: progressContainerView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            // Skip Button Constraints
            skipButton.leadingAnchor.constraint(equalTo: progressContainerView.trailingAnchor, constant: 20),
            skipButton.centerYAnchor.constraint(equalTo: progressContainerView.centerYAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 40),
            skipButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        // Ensure buttons are on top
        self.bringSubviewToFront(backButton)
        self.bringSubviewToFront(skipButton)
    }

    // Configure button properties
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

    // Set progress for the progress view
    func setProgress(_ progress: Float) {
        progressView.setProgress(progress, animated: true)
    }

    // Set visibility for the back button
    func setBackButtonHidden(_ hidden: Bool) {
        backButton.isHidden = hidden
    }

    // Set visibility for the skip button
    func setSkipButtonHidden(_ hidden: Bool) {
        skipButton.isHidden = hidden
    }

    // Back button action handler
    func setBackButtonAction(target: Any, action: Selector) {
        backButton.addTarget(target, action: action, for: .touchUpInside)
    }

    // Skip button action handler
    func setSkipButtonAction(target: Any, action: Selector) {
        skipButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
