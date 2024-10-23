//
//  CoffeeStatusByMood.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 16.10.2024.
//
import UIKit

class CoffeeStatusByMood: UIView {

    let titleLabel = UILabel()
    let mainTitleLabel = UILabel()
    let moodLayerContainer = UIView()
    let moodIconView = UIImageView()
    let moodIconBackgroundView = UIView() // Icon için arka plan
    let recordedLabel = UILabel()
    let topTagsStackView = UIStackView()
    let bottomTagsStackView = UIStackView()
    let mainTagsStackView = UIStackView()
    let actionButton = UIButton()
    let actionButtonBackgroundView = UIView() // Action button için arka plan

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0) // Pastel kahve tonu
        self.layer.cornerRadius = 16

        // Main Title
        mainTitleLabel.text = "Modun Kahvesi"
        mainTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        mainTitleLabel.textAlignment = .left
        mainTitleLabel.textColor = UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0) // Kahverengi ton
        self.addSubview(mainTitleLabel)

        // Subtitle
        titleLabel.text = "Bu modda favorin"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(red: 0.6, green: 0.4, blue: 0.3, alpha: 1.0) // Tarçın rengi
        self.addSubview(titleLabel)

        // Mood Icon arka planı (dairesel)
        moodIconBackgroundView.backgroundColor = UIColor(red: 0.75, green: 0.65, blue: 0.55, alpha: 0.3) // İstediğin renk
        moodIconBackgroundView.layer.cornerRadius = 30 // Daire şekli için büyütüldü
        moodIconBackgroundView.clipsToBounds = true
        self.addSubview(moodIconBackgroundView)

        // Mood Icon
        moodIconView.image = UIImage(named: "1")
        moodIconView.contentMode = .scaleAspectFit
        moodIconBackgroundView.addSubview(moodIconView)

        // Mood Layer Container
        moodLayerContainer.backgroundColor = .clear
        moodLayerContainer.layer.cornerRadius = 10
        moodLayerContainer.clipsToBounds = true
        self.addSubview(moodLayerContainer)

        createMoodSegments()

        // Recorded Label
        recordedLabel.text = "Recorded together with..."
        recordedLabel.font = UIFont.systemFont(ofSize: 14)
        recordedLabel.textColor = UIColor(red: 0.5, green: 0.65, blue: 0.45, alpha: 1.0) // Yeşil kahve tonu
        self.addSubview(recordedLabel)

        // Main Tags StackView
        mainTagsStackView.axis = .vertical
        mainTagsStackView.alignment = .fill
        mainTagsStackView.distribution = .fillEqually
        mainTagsStackView.spacing = 10
        self.addSubview(mainTagsStackView)

        // Top StackView
        topTagsStackView.axis = .horizontal
        topTagsStackView.alignment = .center
        topTagsStackView.distribution = .fillEqually
        topTagsStackView.spacing = 10

        // Bottom StackView
        bottomTagsStackView.axis = .horizontal
        bottomTagsStackView.alignment = .center
        bottomTagsStackView.distribution = .fillEqually
        bottomTagsStackView.spacing = 10

        let topTags = [
            createTagView(iconName: "yogunlukdolu", label: "Tired x12"),
            createTagView(iconName: "yogunlukdolu", label: "Snack x7")
        ]
        
        let bottomTags = [
            createTagView(iconName: "yogunlukdolu", label: "Overtime x5"),
            createTagView(iconName: "yogunlukdolu", label: "Break x4")
        ]
        
        for tag in topTags {
            topTagsStackView.addArrangedSubview(tag)
        }
        
        for tag in bottomTags {
            bottomTagsStackView.addArrangedSubview(tag)
        }

        // Top ve bottom stackview'i main stackview'e ekliyoruz
        mainTagsStackView.addArrangedSubview(topTagsStackView)
        mainTagsStackView.addArrangedSubview(bottomTagsStackView)

        // Action Button arka planı (dairesel)
        actionButtonBackgroundView.backgroundColor = UIColor(red: 0.75, green: 0.65, blue: 0.55, alpha: 0.3) // İstediğin renk
        actionButtonBackgroundView.layer.cornerRadius = 10 // Action button için büyütüldü
        actionButtonBackgroundView.clipsToBounds = true
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        self.addSubview(actionButtonBackgroundView)

        // Action Button
        actionButton.setImage(UIImage(named: "1"), for: .normal)
        actionButton.backgroundColor = .clear
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButtonBackgroundView.addSubview(actionButton)

        setupConstraints()
    }
    
    @objc private func actionButtonTapped() {
          // MoodSelectionView'i ekrana eklemek için bir fonksiyon çağırıyoruz
          if let topView = UIApplication.shared.windows.first?.rootViewController?.view {
              let moodSelectionView = MoodSelectionView(frame: CGRect(x: 0, y: 0, width: topView.frame.width, height: topView.frame.height))
              moodSelectionView.backgroundColor = UIColor.black.withAlphaComponent(0.6) // Arka planı yarı saydam yapıyoruz
              topView.addSubview(moodSelectionView)

              // Görüntüyü animasyonla göster
              moodSelectionView.alpha = 0
              UIView.animate(withDuration: 0.3) {
                  moodSelectionView.alpha = 1
              }
          }
      }

    private func setupConstraints() {
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        moodLayerContainer.translatesAutoresizingMaskIntoConstraints = false
        moodIconView.translatesAutoresizingMaskIntoConstraints = false
        moodIconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        recordedLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTagsStackView.translatesAutoresizingMaskIntoConstraints = false
        topTagsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomTagsStackView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButtonBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // mainTitleLabel ve titleLabel daha yukarıda olacak şekilde düzenlendi
            mainTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20), // Yukarıya taşındı
            mainTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            titleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 20), // Yukarıya taşındı
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            // Mood Icon ve arka planı büyütüldü
            moodIconBackgroundView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            moodIconBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            moodIconBackgroundView.widthAnchor.constraint(equalToConstant: 60), // Büyütüldü
            moodIconBackgroundView.heightAnchor.constraint(equalToConstant: 60), // Büyütüldü

            moodIconView.centerXAnchor.constraint(equalTo: moodIconBackgroundView.centerXAnchor),
            moodIconView.centerYAnchor.constraint(equalTo: moodIconBackgroundView.centerYAnchor),
            moodIconView.widthAnchor.constraint(equalToConstant: 35), // Büyütüldü
            moodIconView.heightAnchor.constraint(equalToConstant: 35), // Büyütüldü

            // Mood Layer Container
            moodLayerContainer.centerYAnchor.constraint(equalTo: moodIconBackgroundView.centerYAnchor),
            moodLayerContainer.leadingAnchor.constraint(equalTo: moodIconBackgroundView.trailingAnchor, constant: 15),
            moodLayerContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            moodLayerContainer.heightAnchor.constraint(equalToConstant: 20),

            recordedLabel.topAnchor.constraint(equalTo: moodIconBackgroundView.bottomAnchor, constant: 20),
            recordedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            mainTagsStackView.topAnchor.constraint(equalTo: recordedLabel.bottomAnchor, constant: 15),
            mainTagsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainTagsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            mainTagsStackView.heightAnchor.constraint(equalToConstant: 120),

            // Üst StackView'in konumlandırılması
            topTagsStackView.topAnchor.constraint(equalTo: recordedLabel.bottomAnchor, constant: 20),

            // Alt StackView'in üst stackview'e göre konumlandırılması
            bottomTagsStackView.topAnchor.constraint(equalTo: topTagsStackView.bottomAnchor, constant: 5), // Buradaki 5 birim boşluk ayarlanabilir

            // Alt StackView'in mainTagsStackView ile hizalanması
            bottomTagsStackView.bottomAnchor.constraint(equalTo: mainTagsStackView.bottomAnchor),

            // Action Button ve arka planı büyütüldü
            actionButtonBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            actionButtonBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            actionButtonBackgroundView.widthAnchor.constraint(equalToConstant: 50), // Büyütüldü
            actionButtonBackgroundView.heightAnchor.constraint(equalToConstant: 50), // Büyütüldü

            actionButton.centerXAnchor.constraint(equalTo: actionButtonBackgroundView.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: actionButtonBackgroundView.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 30), // Büyütüldü
            actionButton.heightAnchor.constraint(equalToConstant: 30), // Büyütüldü

            self.heightAnchor.constraint(equalToConstant: 370),
            self.bottomAnchor.constraint(equalTo: mainTagsStackView.bottomAnchor, constant: 15)
        ])
    }

    private func createMoodSegments() {
        let segmentWidths: [CGFloat] = [0.25, 0.25, 0.25, 0.25] // Orta kahve kaldırıldığı için 4 segment kaldı
        let segmentColors: [UIColor] = [
            UIColor(red: 0.5, green: 0.65, blue: 0.45, alpha: 1.0), // Yeşil kahve tonu
            UIColor(red: 0.9, green: 0.75, blue: 0.55, alpha: 1.0), // Tarçın rengi
            UIColor(red: 0.7, green: 0.5, blue: 0.4, alpha: 1.0),   // Koyu kahverengi
            UIColor(red: 0.35, green: 0.55, blue: 0.35, alpha: 1.0) // Pastel yeşil
        ]

        var previousSegment: UIView? = nil
        for (index, width) in segmentWidths.enumerated() {
            let segmentView = UIView()
            segmentView.backgroundColor = segmentColors[index]
            moodLayerContainer.addSubview(segmentView)

            segmentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                segmentView.topAnchor.constraint(equalTo: moodLayerContainer.topAnchor),
                segmentView.bottomAnchor.constraint(equalTo: moodLayerContainer.bottomAnchor),
                segmentView.widthAnchor.constraint(equalTo: moodLayerContainer.widthAnchor, multiplier: width)
            ])

            if let previous = previousSegment {
                segmentView.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 0).isActive = true
            } else {
                segmentView.leadingAnchor.constraint(equalTo: moodLayerContainer.leadingAnchor).isActive = true
            }

            previousSegment = segmentView
        }
    }


    private func createTagView(iconName: String, label: String) -> UIView {
        let tagContainerView = UIView()
        tagContainerView.backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.94, alpha: 1.0) // Yumuşak pastel ton
        tagContainerView.layer.borderColor = UIColor(red: 0.9, green: 0.85, blue: 0.8, alpha: 1.0).cgColor // Açık pastel kenarlık
        tagContainerView.layer.borderWidth = 1
        tagContainerView.layer.shadowColor = UIColor.black.cgColor
        tagContainerView.layer.shadowOpacity = 0.1
        tagContainerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        tagContainerView.layer.shadowRadius = 3
        tagContainerView.translatesAutoresizingMaskIntoConstraints = false

        let innerStackView = UIStackView()
        innerStackView.axis = .horizontal
        innerStackView.alignment = .center
        innerStackView.spacing = 8 // Daraltılmış aralık
        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        tagContainerView.addSubview(innerStackView)

        // Daireview (Icon arka planı)
        let circularBackgroundView = UIView()
        circularBackgroundView.backgroundColor = UIColor(red: 0.9, green: 0.85, blue: 0.8, alpha: 0.5) // Daire arka plan rengi
        circularBackgroundView.layer.cornerRadius = 14 // Daha küçük radius
        circularBackgroundView.layer.borderColor = UIColor(red: 0.8, green: 0.7, blue: 0.65, alpha: 1.0).cgColor // Kenarlık rengi
        circularBackgroundView.layer.borderWidth = 1
        circularBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView(image: UIImage(named: iconName))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        circularBackgroundView.addSubview(iconImageView)

        let tagLabel = UILabel()
        tagLabel.text = label
        tagLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium) // Daha küçük yazı tipi
        tagLabel.textColor = UIColor(red: 0.4, green: 0.3, blue: 0.2, alpha: 1.0) // Kahverengi tonu
        tagLabel.numberOfLines = 1 // Tek satır olacak
        tagLabel.lineBreakMode = .byTruncatingTail // Uzun metni kes
        tagLabel.minimumScaleFactor = 0.7 // Küçük metinler için ölçekleme
        tagLabel.adjustsFontSizeToFitWidth = true // Uzun metinler için yazı boyutunu küçült
        tagLabel.translatesAutoresizingMaskIntoConstraints = false

        innerStackView.addArrangedSubview(circularBackgroundView)
        innerStackView.addArrangedSubview(tagLabel)

        NSLayoutConstraint.activate([
            innerStackView.leadingAnchor.constraint(equalTo: tagContainerView.leadingAnchor, constant: 10),
            innerStackView.trailingAnchor.constraint(equalTo: tagContainerView.trailingAnchor, constant: -10),
            innerStackView.topAnchor.constraint(equalTo: tagContainerView.topAnchor, constant: 4),
            innerStackView.bottomAnchor.constraint(equalTo: tagContainerView.bottomAnchor, constant: -4),

            circularBackgroundView.widthAnchor.constraint(equalToConstant: 28), // Küçültülmüş daire boyutu
            circularBackgroundView.heightAnchor.constraint(equalToConstant: 28), // Küçültülmüş daire boyutu

            iconImageView.centerXAnchor.constraint(equalTo: circularBackgroundView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: circularBackgroundView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 16), // Küçültülmüş simge boyutu
            iconImageView.heightAnchor.constraint(equalToConstant: 16),

            // TagContainer'ın genişliğini sınırlıyoruz
            tagContainerView.widthAnchor.constraint(lessThanOrEqualToConstant: 120), // Genişlik en fazla 120 olacak
            tagContainerView.heightAnchor.constraint(equalToConstant: 40), // Daha dar yükseklik
        ])

        // Köşe yarıçapını yüksekliğin yarısı olarak ayarlıyoruz
        tagContainerView.layer.cornerRadius = 20

        return tagContainerView
    }
}
