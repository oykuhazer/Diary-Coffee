//
//  ColorPaletteSelectionVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 25.10.2024.
//

import UIKit

class StillSelectionVC: UIViewController {

    let nextButton = UIButton(type: .system)
    let onboardingProgressBarView = OnboardingProgressBarView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let colorPaletteImageView = UIImageView()
    var mainCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)
        
        // Onboarding progress bar ayarları
        onboardingProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        onboardingProgressBarView.setProgress(0.375)
        onboardingProgressBarView.setBackButtonAction(target: self, action: #selector(backButtonTapped))
        onboardingProgressBarView.setSkipButtonAction(target: self, action: #selector(skipButtonTapped))
        self.view.addSubview(onboardingProgressBarView)
        
        // ColorPaletteImageView ayarları
        colorPaletteImageView.translatesAutoresizingMaskIntoConstraints = false
        colorPaletteImageView.image = UIImage(named: "still")
        colorPaletteImageView.contentMode = .scaleAspectFit
        self.view.addSubview(colorPaletteImageView)
        
        // Başlık etiketi ayarları
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Kahvenin Ruhuyla Kendi Stilini Keşfet!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        self.view.addSubview(titleLabel)
        
        // Alt başlık etiketi ayarları
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "Duygularını yansıtan tonları seç ve her fincanda kendine bir yolculuk yarat. Bu stil senin, istediğin her an yeniden şekillendirilebilir."
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        subtitleLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        subtitleLabel.textAlignment = .justified
        subtitleLabel.numberOfLines = 0
        self.view.addSubview(subtitleLabel)
        
        // CollectionView ayarları
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 40, height: 100)
        layout.minimumLineSpacing = 20

        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.register(StillImageGroupCell.self, forCellWithReuseIdentifier: StillImageGroupCell.identifier)
        mainCollectionView.dataSource = self
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.showsHorizontalScrollIndicator = false
        mainCollectionView.backgroundColor = .clear
        self.view.addSubview(mainCollectionView)
        
        // Next Button ayarları
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        nextButton.setTitleColor(UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0), for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.layer.cornerRadius = 10
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        self.view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            onboardingProgressBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            onboardingProgressBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            onboardingProgressBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            onboardingProgressBarView.heightAnchor.constraint(equalToConstant: 20),
            
            colorPaletteImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            colorPaletteImageView.topAnchor.constraint(equalTo: onboardingProgressBarView.bottomAnchor, constant: 50),
            colorPaletteImageView.widthAnchor.constraint(equalToConstant: 150),
            colorPaletteImageView.heightAnchor.constraint(equalToConstant: 150),

            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            titleLabel.topAnchor.constraint(equalTo: colorPaletteImageView.bottomAnchor, constant: 30),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),

            mainCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            mainCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            mainCollectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            mainCollectionView.heightAnchor.constraint(equalToConstant: 220),

            nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func nextButtonTapped() {
        let manageNotificationsVC = ManageNotificationsVC()
        self.navigationController?.pushViewController(manageNotificationsVC, animated: true)
    }

    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func skipButtonTapped() {
        let manageNotificationsVC = ManageNotificationsVC()
        self.navigationController?.pushViewController(manageNotificationsVC, animated: true)
    }
}
