//
//  OnboardingIntroVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class OnboardingIntroVC: UIViewController {

    let onboardingProgressBarView = OnboardingProgressBarView() // OnboardingProgressBarView örneği
    var uiElements: [UIView] = []
    var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation geri butonunu gizle
        self.navigationItem.hidesBackButton = true

        // Sayfa arka plan rengi
        self.view.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)

        // OnboardingProgressBarView ayarları
        onboardingProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(onboardingProgressBarView)

        // Back ve Skip butonlarını gizle
        onboardingProgressBarView.setBackButtonHidden(true)
        onboardingProgressBarView.setSkipButtonHidden(true)

        // Progress'i ayarla
        onboardingProgressBarView.setProgress(0.125)

        // Başlık ekle
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Brewing Memories, One Sip at a Time"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        titleLabel.textAlignment = .center

        // Alt başlık ekle
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "With DailyCoffee, jot down your day’s moments with just a few taps!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        // "Log in account" butonunu ekle
        let loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Log in account", for: .normal)
        loginButton.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)
        loginButton.setTitleColor(UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0), for: .normal)
        loginButton.layer.borderColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0).cgColor
        loginButton.layer.borderWidth = 2
        loginButton.layer.cornerRadius = 10
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        // "Next" butonunu ekle
        nextButton = UIButton(type: .system)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        nextButton.setTitleColor(UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0), for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.layer.cornerRadius = 10

        // "Next" butonu tıklama işlevi
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        // "Updated Terms of Use" yazısı (üstte olacak)
        let updatedTermsLabel = UILabel()
        updatedTermsLabel.translatesAutoresizingMaskIntoConstraints = false
        updatedTermsLabel.text = "*Updated Terms of Use effective from October"
        updatedTermsLabel.font = UIFont.boldSystemFont(ofSize: 13)
        updatedTermsLabel.textColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
        updatedTermsLabel.textAlignment = .center
        updatedTermsLabel.attributedText = NSAttributedString(
            string: updatedTermsLabel.text!,
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )

        // "By pressing [Next]..." yazısı (butonların hemen üstünde olacak)
        let agreementLabel = UILabel()
        agreementLabel.translatesAutoresizingMaskIntoConstraints = false
        agreementLabel.text = "By pressing [Next], you agree to the Terms of Service and Privacy Policy."
        agreementLabel.font = UIFont.boldSystemFont(ofSize: 13)
        agreementLabel.textColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
        agreementLabel.textAlignment = .center
        agreementLabel.numberOfLines = 0

        // Görünümleri view'e ekle
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(loginButton)
        self.view.addSubview(nextButton)
        self.view.addSubview(agreementLabel)
        self.view.addSubview(updatedTermsLabel)

        // UI elemanlarını listeye ekle (progressView hariç)
        uiElements = [titleLabel, subtitleLabel, loginButton, nextButton, updatedTermsLabel, agreementLabel]

        // NSLayoutConstraint ile konumlandırma
        NSLayoutConstraint.activate([
            // OnboardingProgressBarView'in konumlandırılması
            onboardingProgressBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 30),
            onboardingProgressBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -30),
            onboardingProgressBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            onboardingProgressBarView.heightAnchor.constraint(equalToConstant: 20),

            // titleLabel yerleşimi
            titleLabel.topAnchor.constraint(equalTo: onboardingProgressBarView.bottomAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),

            // subtitleLabel yerleşimi
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),

            // AgreementLabel yerleşimi (butonların hemen üstünde)
            agreementLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            agreementLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            agreementLabel.bottomAnchor.constraint(equalTo: updatedTermsLabel.topAnchor, constant: -5),

            // Updated Terms of Use yerleşimi (üstte)
            updatedTermsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            updatedTermsLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            updatedTermsLabel.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),

            // Log in account butonu yerleşimi
            loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            loginButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            // Next butonu yerleşimi
            nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func nextButtonTapped() {
        let genderSelectionVC = GenderSelectionVC()
        self.navigationController?.pushViewController(genderSelectionVC, animated: true)
    }
}
