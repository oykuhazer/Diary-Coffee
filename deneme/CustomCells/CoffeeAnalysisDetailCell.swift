//
//  CoffeeAnalysisDetailCell.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 19.10.2024.
//

import Foundation
import UIKit

class CoffeeAnalysisDetailCell: UITableViewCell {
    
    let rowLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18) // Daha zarif bir font
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let momentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18) // Daha zarif bir font
        label.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0) // Kahve tonlarında açık bej rengi
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 14) // Boyutu biraz büyüttük
        label.textColor = UIColor(red: 0.8, green: 0.7, blue: 0.6, alpha: 1.0) // Daha soluk kahve tonu
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Arka plan rengi
        imageView.backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.94, alpha: 1.0)
        
        // Daire şekli oluşturuyoruz
        imageView.layer.cornerRadius = 25 // Küçültülmüş boyut (yarıçap)
        imageView.layer.masksToBounds = true
        
        // Kenarlık rengi ve kalınlığı
        imageView.layer.borderColor = UIColor(red: 0.9, green: 0.85, blue: 0.8, alpha: 1.0).cgColor
        imageView.layer.borderWidth = 2
        
        // Gölge ekliyoruz
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        imageView.layer.shadowRadius = 4

        return imageView
    }()
    
    func configure(with imageName: String, rowNumber: Int, momentText: String, countText: String) {
        iconImageView.image = UIImage(named: imageName) // Dinamik resim
        rowLabel.text = "\(rowNumber)"
        momentLabel.text = momentText
        countLabel.text = countText
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        addSubview(rowLabel)
        addSubview(imageContainerView)
        imageContainerView.addSubview(iconImageView)
        addSubview(momentLabel)
        addSubview(countLabel)
        
        // Resim View ve Label Constraints
        NSLayoutConstraint.activate([
            rowLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10), // Daha sola alındı
            rowLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor), // Resmin ortasına hizalandı
            rowLabel.widthAnchor.constraint(equalToConstant: 30), // Sıra numarası için genişlik
            
            imageContainerView.leadingAnchor.constraint(equalTo: rowLabel.trailingAnchor, constant: 20), // 10 birim boşluk
            imageContainerView.topAnchor.constraint(equalTo: centerYAnchor, constant: -10), // Resim biraz aşağı indirildi
            imageContainerView.widthAnchor.constraint(equalToConstant: 40), // Küçültülmüş boyut
            imageContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            iconImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor), // Resim container içinde ortalanıyor
            iconImageView.widthAnchor.constraint(equalToConstant: 50), // Küçültülmüş daire
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            momentLabel.leadingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: 20),
            momentLabel.centerYAnchor.constraint(equalTo: centerYAnchor), // Label'ın tam ortalanması
            
            countLabel.leadingAnchor.constraint(equalTo: momentLabel.leadingAnchor),
            countLabel.topAnchor.constraint(equalTo: momentLabel.bottomAnchor, constant: 3) // "x2", "x5" etiketi
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

