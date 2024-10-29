//
//  ProfileVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 20.10.2024.
//

import UIKit

class ProfileVC: UIViewController {

    private let scrollView = UIScrollView() // UIScrollView oluştur
    private let contentView = UIView() // İçerik view oluştur (scrollable içerik)

    private let premiumView = PremiumView() // PremiumView'i oluştur
    private let accountView = AccountView() // AccountView'i oluştur
    private let recordsView = RecordsView() // RecordsView'i oluştur
    private let featuresView = FeaturesView() // Yeni FeaturesView ekleyin

    override func viewDidLoad() {
        super.viewDidLoad()

        // Arka plan rengini ayarla
        view.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        
        // Navigation Bar ayarları
        setupNavigationBar()

        // ScrollView ve ContentView'i ekleyin
        setupScrollView()
        setupContentView()

        // İçerik view'inin altına diğer view'leri ekleyin
        setupPremiumView()
        setupAccountView()
        setupRecordsView()
        setupFeaturesView() // FeaturesView'i ekleyin
    }

    private func setupNavigationBar() {
        // Navigation bar arka plan rengini ayarla
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        
        // Navigation bar başlık rengini ayarla
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)
        ]
        
        // Başlığı ayarla
        self.title = "My Info"
        
        // Back button'u gizle
        navigationItem.hidesBackButton = true
        
        // Bell ve gearshape butonlarını oluşturun
        let bellButton = UIButton(type: .system)
        bellButton.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        bellButton.tintColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)
        bellButton.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)
        
        // Bell button'un çerçevesini ayarlayıp sola kaydırın
        bellButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -80, bottom: 0, right: 0)

        let settingsButton = UIButton(type: .system)
        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.tintColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)

        // Settings button'un çerçevesini ayarlayıp sola kaydırın
        settingsButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)

        // StackView ile butonları yan yana ekleyin
        let buttonStackView = UIStackView(arrangedSubviews: [bellButton, settingsButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = -5 // Butonları daha da yaklaştırmak için negatif spacing
        buttonStackView.distribution = .fillProportionally

        // Custom view olarak navigation item'a ekleyin
        let barButtonItem = UIBarButtonItem(customView: buttonStackView)
        navigationItem.rightBarButtonItem = barButtonItem
    }





   


    // Zil butonuna tıklandığında çalışacak fonksiyon
    @objc private func bellButtonTapped() {
        print("Bell button tapped")
    }

    // Ayarlar butonuna tıklandığında çalışacak fonksiyon
    @objc private func settingsButtonTapped() {
        print("Settings button tapped")
    }

    private func setupScrollView() {
        // ScrollView'i ana görünüme ekleyin
        view.addSubview(scrollView)

        // Auto Layout için translatesAutoresizingMaskIntoConstraints'ı false yapın
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        // Auto Layout kurallarını ekleyin
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupContentView() {
        // ContentView'i ScrollView'e ekleyin
        scrollView.addSubview(contentView)

        // Auto Layout için translatesAutoresizingMaskIntoConstraints'ı false yapın
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // ContentView'in genişliği ve yüksekliği ScrollView ile uyumlu olmalı
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Genişlik sabit
        ])
    }

    private func setupPremiumView() {
        // PremiumView'i contentView'e ekleyin
        contentView.addSubview(premiumView)

        // Auto Layout için translatesAutoresizingMaskIntoConstraints'ı false yapın
        premiumView.translatesAutoresizingMaskIntoConstraints = false

        // Auto Layout kurallarını ekleyin
        NSLayoutConstraint.activate([
            premiumView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            premiumView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            premiumView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            premiumView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }

    private func setupAccountView() {
        // AccountView'i PremiumView'in altına ekleyin
        contentView.addSubview(accountView)

        // Auto Layout için translatesAutoresizingMaskIntoConstraints'ı false yapın
        accountView.translatesAutoresizingMaskIntoConstraints = false

        // Auto Layout kurallarını ekleyin
        NSLayoutConstraint.activate([
            accountView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            accountView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            accountView.topAnchor.constraint(equalTo: premiumView.bottomAnchor, constant: 80),
            accountView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    private func setupRecordsView() {
        contentView.addSubview(recordsView)

        recordsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            recordsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recordsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recordsView.topAnchor.constraint(equalTo: accountView.bottomAnchor, constant: 40),
            recordsView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func setupFeaturesView() {
        contentView.addSubview(featuresView)

        featuresView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            featuresView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            featuresView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            featuresView.topAnchor.constraint(equalTo: recordsView.bottomAnchor, constant: 65),
            featuresView.heightAnchor.constraint(equalToConstant: 60),
            featuresView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -180) // Alt boşluk ekleyin
        ])
    }
}
