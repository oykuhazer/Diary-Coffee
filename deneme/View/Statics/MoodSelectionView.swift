//
//  MoodSelectionView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 18.10.2024.
//

import UIKit

class MoodSelectionView: UIView {

    private let coffeeToneView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.6, green: 0.45, blue: 0.35, alpha: 1.0) // Koyu kahve tonu
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let images: [UIView] = {
        let imageNames = ["a", "b", "c", "d", "e", "f"]
        return imageNames.map {
            let containerView = UIView()
            containerView.layer.cornerRadius = 45 // Daire şekli için yarıçap (90x90 boyut)
            containerView.backgroundColor = UIColor(red: 0.8, green: 0.7, blue: 0.6, alpha: 1.0) // Açık kahve arka plan
            containerView.layer.shadowColor = UIColor.black.cgColor // Gölge eklendi
            containerView.layer.shadowOpacity = 0.2
            containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
            containerView.layer.shadowRadius = 6
            containerView.layer.masksToBounds = false
            containerView.translatesAutoresizingMaskIntoConstraints = false

            let imageView = UIImageView(image: UIImage(named: $0))
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 40 // Resmin köşe yarıçapı
            imageView.layer.masksToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false

            containerView.addSubview(imageView)

            // Resmin containerView içinde ortalanması
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 70), // Resim boyutu
                imageView.heightAnchor.constraint(equalToConstant: 70),

                containerView.widthAnchor.constraint(equalToConstant: 90), // Daire boyutu
                containerView.heightAnchor.constraint(equalToConstant: 90)
            ])
            
            return containerView
        }
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor(red: 0.9, green: 0.85, blue: 0.75, alpha: 1.0) // Açık kahve tonunda arka plan
        addSubview(coffeeToneView)
        
        // coffeeToneView'in tam ortalanması
        NSLayoutConstraint.activate([
            coffeeToneView.centerXAnchor.constraint(equalTo: centerXAnchor),
            coffeeToneView.centerYAnchor.constraint(equalTo: centerYAnchor), // Tam ortada
            coffeeToneView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            coffeeToneView.heightAnchor.constraint(equalToConstant: 280) // Yükseklik azaltıldı
        ])
        
        // Resimlerin manuel olarak biraz daha aşağıda konumlandırılması
        for (index, containerView) in images.enumerated() {
            coffeeToneView.addSubview(containerView)
            
            let row = index / 3 // 0. satır: üst, 1. satır: alt
            let column = index % 3 // 0: sol, 1: orta, 2: sağ
            
            NSLayoutConstraint.activate([
                containerView.centerXAnchor.constraint(equalTo: coffeeToneView.centerXAnchor, constant: CGFloat((column - 1) * 120)), // Yatayda ortalanmış 3 resim
                containerView.centerYAnchor.constraint(equalTo: coffeeToneView.centerYAnchor, constant: CGFloat((row - 1) * 120) + 60) // Daha aşağıda olacak şekilde konumlandırıldı
            ])
        }
    }
}
