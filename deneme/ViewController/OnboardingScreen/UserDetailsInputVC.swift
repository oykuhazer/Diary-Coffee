//
//  UserDetailsInputVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class UserDetailsInputVC: UIViewController, UITextFieldDelegate {

    let nextButton = UIButton(type: .system)
    let onboardingProgressBarView = OnboardingProgressBarView()

    let nameTextFieldView = NameTextFieldView() // Custom NameTextFieldView
    let birthdayButtonView = BirthdayButtonView() // Custom BirthdayButtonView
    let birthdayDatePickerView = BirthdayDatePickerView() // Custom BirthdayDatePickerView
    let birthdayImageView = UIImageView() // Birthday image
    
   let keyboardManager = KeyboardManager() // KeyboardManager sınıfını kullanıyoruz
    
    var isDateSelected = false // Tarih seçimi durumunu izlemek için

    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation geri butonunu gizle
        self.navigationItem.hidesBackButton = true

        // Sayfa arka plan rengi
        self.view.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)

        // OnboardingProgressBarView ayarları
        onboardingProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        onboardingProgressBarView.setProgress(0.375) // İlerleme %37.5 olarak ayarlanıyor
        onboardingProgressBarView.setBackButtonAction(target: self, action: #selector(backButtonTapped))
        onboardingProgressBarView.setSkipButtonAction(target: self, action: #selector(skipButtonTapped))
        self.view.addSubview(onboardingProgressBarView)

        // Birthday image
        birthdayImageView.image = UIImage(named: "birthday") // Assume the image is named "birthday" in your assets
        birthdayImageView.contentMode = .scaleAspectFit
        birthdayImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(birthdayImageView)

        // Title label
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "🎉 Let's Make It Special! 🎉"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)

        // Subtitle label
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "What's your name? 🌟 And when's your birthday? 🎂"
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        subtitleLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        self.view.addSubview(subtitleLabel)

        // Secondary subtitle label (lighter)
        let secondarySubtitleLabel = UILabel()
        secondarySubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        secondarySubtitleLabel.text = "We’d love to celebrate you by sending a special surprise of clovers 🍀 on your big day! 🎁"
        secondarySubtitleLabel.font = UIFont.systemFont(ofSize: 16)
        secondarySubtitleLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        secondarySubtitleLabel.textAlignment = .center
        secondarySubtitleLabel.numberOfLines = 0
        self.view.addSubview(secondarySubtitleLabel)

        // Add the custom NameTextFieldView
        nameTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(nameTextFieldView)

        // Klavyeyi büyük harf modunda açma ayarı
        keyboardManager.configureUppercaseKeyboard(for: nameTextFieldView.textField)

        // Add the custom BirthdayButtonView
        birthdayButtonView.translatesAutoresizingMaskIntoConstraints = false
        birthdayButtonView.datePickerView = birthdayDatePickerView // Set the datePickerView reference
        self.view.addSubview(birthdayButtonView)

        // Add the custom BirthdayDatePickerView
        birthdayDatePickerView.translatesAutoresizingMaskIntoConstraints = false
        birthdayDatePickerView.isHidden = true // Initially hidden
        self.view.addSubview(birthdayDatePickerView)

        // Sayfaya dokunmayla klavyeyi kapatma ayarı
        keyboardManager.addTapToDismissKeyboard(to: view)

        // Next button ayarları
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor =  UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
        nextButton.setTitleColor(UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0), for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.layer.cornerRadius = 10
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        self.view.addSubview(nextButton)

        // NameTextFieldView içinde olan UITextField'da değişiklikleri izleme
        nameTextFieldView.textField.delegate = self
        nameTextFieldView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // BirthdayButtonView için parentVC referansı ayarlanır
        birthdayButtonView.setParentVC(vc: self)
        
        // Next button ilk durum
        updateNextButtonState()

        // Layout Constraints
        NSLayoutConstraint.activate([
            onboardingProgressBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            onboardingProgressBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            onboardingProgressBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            onboardingProgressBarView.heightAnchor.constraint(equalToConstant: 20),

            birthdayImageView.topAnchor.constraint(equalTo: onboardingProgressBarView.bottomAnchor, constant: 60),
            birthdayImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            birthdayImageView.widthAnchor.constraint(equalToConstant: 150),
            birthdayImageView.heightAnchor.constraint(equalToConstant: 150),

            titleLabel.topAnchor.constraint(equalTo: birthdayImageView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),

            secondarySubtitleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            secondarySubtitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            secondarySubtitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),

            nameTextFieldView.topAnchor.constraint(equalTo: secondarySubtitleLabel.bottomAnchor, constant: 50),
            nameTextFieldView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nameTextFieldView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nameTextFieldView.heightAnchor.constraint(equalToConstant: 50),

            birthdayButtonView.topAnchor.constraint(equalTo: nameTextFieldView.bottomAnchor, constant: 30),
            birthdayButtonView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            birthdayButtonView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            birthdayButtonView.heightAnchor.constraint(equalToConstant: 50),

            birthdayDatePickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            birthdayDatePickerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            birthdayDatePickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            birthdayDatePickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            birthdayDatePickerView.heightAnchor.constraint(equalToConstant: 250),

            nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateNextButtonState()
    }

    func dateSelected() {
        isDateSelected = true
        updateNextButtonState()
    }

    func updateNextButtonState() {
        let isTextValid = nameTextFieldView.textField.text?.count ?? 0 >= 3

        if isTextValid && isDateSelected {
            nextButton.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
            nextButton.isEnabled = true
        } else {
            nextButton.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
            nextButton.isEnabled = false
        }
    }

    @objc func nextButtonTapped() {
        let stillSelectionVC = StillSelectionVC()
        self.navigationController?.pushViewController(stillSelectionVC, animated: true)
    }

    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func skipButtonTapped() {
        // İsim ve tarih doğrulaması yapılır
        let isTextValid = nameTextFieldView.textField.text?.count ?? 0 >= 3

        if isTextValid && isDateSelected {
            // Koşullar sağlandığında geçiş yapılır
            let stillSelectionVC = StillSelectionVC()
            self.navigationController?.pushViewController(stillSelectionVC, animated: true)
        } else {
           
        }
    }
}
