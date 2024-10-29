//
//  AccountView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 23.10.2024.
//

import UIKit

class AccountView: UIView {

    // Custom initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    // Required initializer for using custom views from Interface Builder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // Setting up the view with minimalist design
    private func setupView() {
        // Arka plan rengini ayarla
        self.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 16

        let accountLabel = UILabel()
        accountLabel.text = "Account"
        accountLabel.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)
        accountLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        accountLabel.textAlignment = .center
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Daire şekilli bir view oluştur
        let circularView = UIView()
        circularView.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)  // Minimalist tasarım için nötr kahve tonları
        circularView.translatesAutoresizingMaskIntoConstraints = false
        circularView.layer.cornerRadius = 30  // Daire şekli için köşe yuvarlama
        circularView.clipsToBounds = false  // Gölge görünümü için clipsToBounds false yapılmalı

        // Kenarlık ekle
        circularView.layer.borderWidth = 1  // İnce ve sade bir kenarlık
        circularView.layer.borderColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0).cgColor  // Hafif açık tonlarda kenarlık
        
        // Gölge ekle
        circularView.layer.shadowColor = UIColor.black.cgColor
        circularView.layer.shadowOpacity = 0.15  // Daha yumuşak ve hafif bir gölge
        circularView.layer.shadowOffset = CGSize(width: 0, height: 2)  // Daha küçük bir gölge
        circularView.layer.shadowRadius = 3  // Gölge yayılma genişliği azaltıldı

        // UIImageView oluştur ve asset dosyasındaki 'd' resmini ekle
        let imageView = UIImageView(image: UIImage(named: "d"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Kullanıcı adı için UILabel oluştur
        let nameLabel = UILabel()
        nameLabel.text = "Öykü Hazer Ekinci"
        nameLabel.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)  // Verilen renkte yazı
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Kullanıcı ID'si için UILabel oluştur
        let userIDLabel = UILabel()
        userIDLabel.text = "User ID: 15011196"
        userIDLabel.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)  // Verilen renkte yazı
        userIDLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        userIDLabel.translatesAutoresizingMaskIntoConstraints = false

        // Chevron butonunu oluştur
        let chevronButton = UIButton()
        chevronButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        chevronButton.tintColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)  // Chevron rengi
        chevronButton.translatesAutoresizingMaskIntoConstraints = false

        // UILabel'leri, UIImageView'i ve Chevron'u ana view'e ekle
        self.addSubview(circularView)
        circularView.addSubview(imageView)
        self.addSubview(nameLabel)
        self.addSubview(userIDLabel)
        self.addSubview(chevronButton)
        self.addSubview(accountLabel)
      
        NSLayoutConstraint.activate([
        
        accountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -40),
        accountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            
            circularView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            circularView.centerYAnchor.constraint(equalTo: self.centerYAnchor),  // View ortalanacak
            circularView.widthAnchor.constraint(equalToConstant: 60),
            circularView.heightAnchor.constraint(equalToConstant: 60),
            
            // UIImageView için (daha büyük resim)
            imageView.centerXAnchor.constraint(equalTo: circularView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circularView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            // NameLabel için (resmin sağına hizalanacak ve ortalanacak)
            nameLabel.leadingAnchor.constraint(equalTo: circularView.trailingAnchor, constant: 30),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15),  // Ortalanmış, yukarı kaydırıldı
            
            // UserIDLabel için (nameLabel'ın altında ortalanacak)
            userIDLabel.leadingAnchor.constraint(equalTo: circularView.trailingAnchor, constant: 30),
            userIDLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15),  // Ortalanmış, aşağı kaydırıldı

            // Chevron butonunu hizala (sağa dayalı ve ortalanacak)
            chevronButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            chevronButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),  // Sağ kenardan 15 birim boşluk
            chevronButton.widthAnchor.constraint(equalToConstant: 20),
            chevronButton.heightAnchor.constraint(equalToConstant: 20)
        ])

    }
}
