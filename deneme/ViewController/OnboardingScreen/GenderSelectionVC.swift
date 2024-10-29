//
//  GenderSelectionVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class GenderSelectionVC: UIViewController {

    let onboardingProgressBarView = OnboardingProgressBarView()
    let nextButton = UIButton(type: .system)
    let maleView = UIView()
    let femaleView = UIView()
    let otherView = UIView()

    var genderSelected = false {
        didSet {
            updateNextButtonState()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation geri butonunu gizle
        self.navigationItem.hidesBackButton = true

        // Sayfa arka plan rengi
        self.view.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)

        // OnboardingProgressBarView ayarları
        onboardingProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        onboardingProgressBarView.setProgress(0.25) // İlerleme %25 olarak ayarlanıyor
        onboardingProgressBarView.setBackButtonAction(target: self, action: #selector(backButtonTapped))
        onboardingProgressBarView.setSkipButtonAction(target: self, action: #selector(skipButtonTapped))
        self.view.addSubview(onboardingProgressBarView)

        // Başlık label ayarları
        let titleLabel = UILabel()
        titleLabel.text = "Let’s Get to Know You Better!"
        titleLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)

        // Alt başlık label ayarları
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Let us personalize your journey—choose your gender for a tailored experience!"
        subtitleLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subtitleLabel)

        // Ortak View ayarları
        setupGenderView(view: maleView, imageName: "male", labelText: "Male", tapAction: #selector(selectMale))
        setupGenderView(view: femaleView, imageName: "female", labelText: "Female", tapAction: #selector(selectFemale))
        setupGenderView(view: otherView, imageName: "other", labelText: "Other", tapAction: #selector(selectOther))

        // View'leri bir StackView'e ekleyerek yan yana yerleştirme
        let stackView = UIStackView(arrangedSubviews: [maleView, femaleView, otherView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        self.view.addSubview(stackView)

        // Next butonu ayarları
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
        nextButton.setTitleColor(UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0), for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.layer.cornerRadius = 10
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        self.view.addSubview(nextButton)

        // Yerleşim kısıtlamaları
        NSLayoutConstraint.activate([
            // OnboardingProgressBarView'in yerleşimi
            onboardingProgressBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            onboardingProgressBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
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

            // StackView yerleşimi
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 110),

            // Next butonunun yerleşimi
            nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // Ortak View ayar fonksiyonu
    func setupGenderView(view: UIView, imageName: String, labelText: String, tapAction: Selector) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true

        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = labelText
        label.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)
        view.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 130),
            view.heightAnchor.constraint(equalToConstant: 110)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: tapAction)
        view.addGestureRecognizer(tapGesture)
    }

    // Seçim işlemleri
    @objc func selectMale() {
        resetGenderSelection()
        maleView.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        genderSelected = true
    }

    @objc func selectFemale() {
        resetGenderSelection()
        femaleView.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        genderSelected = true
    }

    @objc func selectOther() {
        resetGenderSelection()
        otherView.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        genderSelected = true
    }

    // Tüm karelerin rengini sıfırlama
    func resetGenderSelection() {
        maleView.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
        femaleView.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
        otherView.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
        genderSelected = false
    }

    // "Next" butonunun durumunu güncelleme
    func updateNextButtonState() {
        if genderSelected {
            nextButton.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        } else {
            nextButton.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
        }
    }

    @objc func nextButtonTapped() {
        // Eğer seçim yapılmadıysa geçişe izin verme
        if !genderSelected {
            print("No gender selected, transition not allowed.")
            return
        }

        // Seçim yapıldıysa UserDetailsInputVC'ye geçiş yap
        let userDetailsVC = UserDetailsInputVC()
        self.navigationController?.pushViewController(userDetailsVC, animated: true)
    }

    @objc func backButtonTapped() {
        // OnboardingIntroVC'ye geri dön
        let onboardingVC = OnboardingIntroVC()
        self.navigationController?.pushViewController(onboardingVC, animated: true)
    }

    @objc func skipButtonTapped() {
        // Eğer seçim yapıldıysa UserDetailsInputVC'ye geçiş yap, yapılmadıysa geçiş yapma
        if genderSelected {
            let userDetailsVC = UserDetailsInputVC()
            self.navigationController?.pushViewController(userDetailsVC, animated: true)
        } else {
            print("No gender selected, skipping not allowed.")
        }
    }
}
