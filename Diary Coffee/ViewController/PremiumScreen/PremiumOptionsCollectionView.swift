//
//  PremiumOptionsCollectionView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 21.11.2024.
//

import UIKit

class PremiumOptionsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let cellIdentifier = "PremiumOptionCell"

   
    private let options: [(title: String, subtitle: String, imageName: String)] = [
        (
            NSLocalizedString("in_depth_analysis", comment: ""),
            NSLocalizedString("in_depth_analysis_desc", comment: ""),
            "danalysis"
        ),
        (
            NSLocalizedString("up_to_3_photos", comment: ""),
            NSLocalizedString("up_to_3_photos_desc", comment: ""),
            "photos"
        ),
        (
            NSLocalizedString("daily_entries", comment: ""),
            NSLocalizedString("daily_entries_desc", comment: ""),
            "daily"
        ),
        (
            NSLocalizedString("special_gift", comment: ""),
            NSLocalizedString("special_gift_desc", comment: ""),
            "beans"
        )
    ]


    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        super.init(frame: .zero, collectionViewLayout: layout)
        self.isScrollEnabled = false
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false

        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)

        cell.backgroundColor = AppColors.color3
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

     
        let option = options[indexPath.item]

        if indexPath.item == 3 {
          
            let loveImageView = UIImageView()
            loveImageView.image = UIImage(named: "love")
            loveImageView.contentMode = .scaleAspectFit
            loveImageView.translatesAutoresizingMaskIntoConstraints = false

            let smileImageView = UIImageView()
            smileImageView.image = UIImage(named: "smile")
            smileImageView.contentMode = .scaleAspectFit
            smileImageView.translatesAutoresizingMaskIntoConstraints = false

            cell.contentView.addSubview(loveImageView)
            cell.contentView.addSubview(smileImageView)

            let customTitleLabel = UILabel()
            customTitleLabel.text = NSLocalizedString("express_your_mood", comment: "")
            customTitleLabel.textColor = AppColors.color5
            customTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            customTitleLabel.textAlignment = .center
            customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(customTitleLabel)

            let customSubtitleLabel = UILabel()
            customSubtitleLabel.text = NSLocalizedString("express_your_mood_desc", comment: "")
            customSubtitleLabel.textColor = AppColors.color7
            customSubtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            customSubtitleLabel.numberOfLines = 0
            customSubtitleLabel.textAlignment = .left
            customSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(customSubtitleLabel)

            NSLayoutConstraint.activate([
               
                loveImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: -10),
                loveImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -40),
                loveImageView.widthAnchor.constraint(equalToConstant: 50),
                loveImageView.heightAnchor.constraint(equalToConstant: 50),

              
                smileImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: 20),
                smileImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
                smileImageView.widthAnchor.constraint(equalToConstant: 50),
                smileImageView.heightAnchor.constraint(equalToConstant: 50),

                customTitleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 30),
                customTitleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                customTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: smileImageView.leadingAnchor, constant: -24),

                
                customSubtitleLabel.topAnchor.constraint(equalTo: customTitleLabel.bottomAnchor, constant: 15),
                customSubtitleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                customSubtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: smileImageView.leadingAnchor, constant: -40),
                customSubtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: cell.contentView.bottomAnchor, constant: -20),

            ])
        } else {
          
            let titleLabel = UILabel()
            titleLabel.text = option.title
            titleLabel.textColor = AppColors.color5
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

         
            let subtitleLabel = UILabel()
            subtitleLabel.text = option.subtitle
            subtitleLabel.textColor = AppColors.color7
            subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            subtitleLabel.numberOfLines = 0
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

           
            let imageView = UIImageView()
            imageView.image = UIImage(named: option.imageName)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false

            cell.contentView.addSubview(titleLabel)
            cell.contentView.addSubview(subtitleLabel)
            cell.contentView.addSubview(imageView)

            NSLayoutConstraint.activate([
              
                titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 30),
                titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -24),

             
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
                subtitleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -40),
                subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: cell.contentView.bottomAnchor, constant: -20),

             
                imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                imageView.widthAnchor.constraint(equalToConstant: 80),
                imageView.heightAnchor.constraint(equalToConstant: 80)
            ])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20
        return CGSize(width: width, height: 150) 
    }
}
