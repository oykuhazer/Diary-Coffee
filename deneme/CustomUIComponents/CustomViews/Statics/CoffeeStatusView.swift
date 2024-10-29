//
//  CoffeeStatsView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 16.10.2024.
//

import Foundation
import UIKit


protocol CoffeeStatusViewDelegate: AnyObject {
    func didTapCoffeeMoreButton()
}


class CoffeeStatusView: UIView {
    
    weak var delegate: CoffeeStatusViewDelegate?
    
    let titleLabel = UILabel() // "Frequently Recorded" yazısı için
    var momentsDescriptionLabel = UILabel() // Yeni eklenen açıklama yazısı
    let moreButton = UIButton(type: .system)
    let momentsStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        // Arka plan ve genel yapı
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0) // Yumuşak bej arka plan
        self.layer.cornerRadius = 16


        // Başlık (sol üstte)
        titleLabel.text = "Favori Kahvelerin"
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0) // Kahverengi ton
        self.addSubview(titleLabel)

        momentsDescriptionLabel = UILabel()

        let fullText = "En çok keyif aldığın   Kahve"
        let attributedText = NSMutableAttributedString(string: fullText)

        // "En çok keyif aldığın deneyimlerin" kahverengi olacak
        let brownColor = UIColor(red: 0.45, green: 0.35, blue: 0.25, alpha: 1.0) // Yumuşak kahverengi ton
        let brownFont = UIFont(name: "HelveticaNeue-Bold", size: 18)! // Kalın ve belirgin font
        attributedText.addAttribute(.foregroundColor, value: brownColor, range: (fullText as NSString).range(of: "En çok keyif aldığın"))
        attributedText.addAttribute(.font, value: brownFont, range: (fullText as NSString).range(of: "En çok keyif aldığın"))

        // "kahve" yeşil olacak
        let greenColor = UIColor(red: 0.35, green: 0.55, blue: 0.35, alpha: 1.0) // Yeşil pastel ton
        let greenFont = UIFont(name: "HelveticaNeue-BoldItalic", size: 18)! // Kalın ve italik font
        attributedText.addAttribute(.foregroundColor, value: greenColor, range: (fullText as NSString).range(of: "Kahve"))
        attributedText.addAttribute(.font, value: greenFont, range: (fullText as NSString).range(of: "Kahve"))

        // Karakter aralığı ve satır aralığı ekleyerek daha estetik bir görüntü sağlama
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, fullText.count))
        attributedText.addAttribute(.kern, value: 0.8, range: NSMakeRange(0, fullText.count))

        // Label'e ayarları uygulama
        momentsDescriptionLabel.attributedText = attributedText
        momentsDescriptionLabel.textAlignment = .center
        momentsDescriptionLabel.numberOfLines = 0
        momentsDescriptionLabel.adjustsFontSizeToFitWidth = true
        momentsDescriptionLabel.minimumScaleFactor = 0.5
        self.addSubview(momentsDescriptionLabel)



        // More butonu (sağ üstte)
        let moreImage = UIImage(systemName: "ellipsis")
        moreButton.setImage(moreImage, for: .normal)
        moreButton.tintColor = UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside) // Tıklama olayı
        self.addSubview(moreButton)

        // Moments StackView ayarları
        momentsStackView.axis = .horizontal
        momentsStackView.alignment = .center
        momentsStackView.distribution = .fillEqually
        momentsStackView.spacing = 10
        self.addSubview(momentsStackView)

        // 3 Moment için view'ler oluşturma
        let moments = [
            createMomentView(rank: "1", imageName: "yogunlukdolu", label: "calm", count: "x1"),
            createMomentView(rank: "2", imageName: "yogunlukdolu", label: "family", count: "x1"),
            createMomentView(rank: "3", imageName: "yogunlukdolu", label: "stormy", count: "x1")
        ]

        for moment in moments {
            momentsStackView.addArrangedSubview(moment)
        }

        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        momentsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        momentsStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),

            momentsDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            momentsDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),

            moreButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            moreButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            momentsStackView.topAnchor.constraint(equalTo: momentsDescriptionLabel.bottomAnchor, constant: 30),
            momentsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            momentsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            momentsStackView.heightAnchor.constraint(equalToConstant: 180),

            self.heightAnchor.constraint(equalToConstant: 320)
        ])
    }

    private func createMomentView(rank: String, imageName: String, label: String, count: String) -> UIView {
        let momentView = UIView()
        momentView.layer.cornerRadius = 12
        momentView.backgroundColor = UIColor(red: 0.4, green: 0.3, blue: 0.25, alpha: 1.0) // Koyu kahve tonu
        momentView.layer.shadowColor = UIColor.black.cgColor
        momentView.layer.shadowOpacity = 0.2
        momentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        momentView.layer.shadowRadius = 6
        momentView.translatesAutoresizingMaskIntoConstraints = false

        // Daire View (Tek renk ve daha açık ton)
        let circleView = UIView()
        circleView.layer.cornerRadius = 35
        circleView.backgroundColor = UIColor(red: 0.85, green: 0.75, blue: 0.65, alpha: 1.0) // Tek renk, açık pastel ton
        circleView.layer.shadowColor = UIColor.black.cgColor
        circleView.layer.shadowOpacity = 0.1
        circleView.layer.shadowOffset = CGSize(width: 0, height: 2)
        circleView.layer.shadowRadius = 4
        circleView.translatesAutoresizingMaskIntoConstraints = false
        momentView.addSubview(circleView)

        // Resim
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.white  // Beyaz kontrast
        circleView.addSubview(imageView)

        // Rank Label (Açık renk kontrast)
        let rankLabel = UILabel()
        rankLabel.text = rank
        rankLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        rankLabel.textColor = UIColor(red: 0.85, green: 0.75, blue: 0.65, alpha: 1.0) // Açık pastel ton
        rankLabel.textAlignment = .left
        momentView.addSubview(rankLabel)

        // Description Label (Açık renk kontrast)
        let descriptionLabel = UILabel()
        descriptionLabel.text = label
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0) // Daha açık kahve tonu
        descriptionLabel.textAlignment = .center
        momentView.addSubview(descriptionLabel)

        // Count Label (Daha açık ve sade)
        let countLabel = UILabel()
        countLabel.text = count
        countLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        countLabel.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0) // Açık pastel ton
        countLabel.textAlignment = .center
        momentView.addSubview(countLabel)

        // Constraint'ler
        circleView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            rankLabel.topAnchor.constraint(equalTo: momentView.topAnchor, constant: 10),
            rankLabel.leadingAnchor.constraint(equalTo: momentView.leadingAnchor, constant: 12),

            circleView.topAnchor.constraint(equalTo: rankLabel.bottomAnchor, constant: 5),
            circleView.centerXAnchor.constraint(equalTo: momentView.centerXAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 70),
            circleView.heightAnchor.constraint(equalToConstant: 70),

            imageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),

            descriptionLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: momentView.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: momentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: momentView.trailingAnchor, constant: -16),

            countLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            countLabel.centerXAnchor.constraint(equalTo: momentView.centerXAnchor),
            countLabel.bottomAnchor.constraint(equalTo: momentView.bottomAnchor, constant: -10)
        ])

        return momentView
    }
    
    @objc private func moreButtonTapped() {
           delegate?.didTapCoffeeMoreButton() // Delegate üzerinden çağrı
       }
}
