//
//  PrimeEmotionSetCell.swift
//  DailyCoffee
//
//  Created by Öykü Hazer Ekinci on 10.12.2024.
//

import UIKit

class PrimeEmotionSetCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    static let identifier = "PrimeEmotionSetCell"
    
     var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
         label.textColor = AppColors.color22
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
        }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppColors.color27
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = -20
        layout.minimumLineSpacing = -20
        layout.sectionInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PrimeEmotionImageCell.self, forCellWithReuseIdentifier: PrimeEmotionImageCell.identifier)

        return collectionView
    }()
    
    private var images: [String] = []
    private let coffeeLabel: UILabel = UILabel()
    
    private let subtitles: [String: String] = [
        "Animal": NSLocalizedString("natures_joy", comment: ""),
        "Autumn": NSLocalizedString("golden_leaves", comment: ""),
        "Camping": NSLocalizedString("camping", comment: ""),
        "Christmas": NSLocalizedString("warm_lights", comment: ""),
        "Halloween": NSLocalizedString("spooky_thrills", comment: ""),
        "Dessert": NSLocalizedString("sweet_bites", comment: ""),
        "Friends": NSLocalizedString("laughter_louder", comment: ""),
        "Love": NSLocalizedString("heartbeats_shared", comment: ""),
        "Night": NSLocalizedString("stars_whisper", comment: ""),
        "Party": NSLocalizedString("dancing_nights", comment: ""),
        "Hobby": NSLocalizedString("time_fades", comment: ""),
        "School": NSLocalizedString("learning_laughter", comment: ""),
        "Spring": NSLocalizedString("colors_bloom", comment: ""),
        "Snow": NSLocalizedString("cozy_warmth", comment: ""),
        "Summer": NSLocalizedString("golden_rays", comment: ""),
        "Working": NSLocalizedString("dreams_realized", comment: "")
    ]

    
    func getSubtitle(for title: String) -> String? {
          return subtitles[title]
      }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = AppColors.color22
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        coffeeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(coffeeLabel)
        configureCoffeeLabel(for: "300")
        
        contentView.addSubview(imagesCollectionView)
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
             titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
                subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            imagesCollectionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imagesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imagesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imagesCollectionView.heightAnchor.constraint(equalToConstant: 80),
        
            coffeeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            coffeeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 40),
            coffeeLabel.heightAnchor.constraint(equalToConstant: 30),
            coffeeLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, images: [String], showCoffeeLabel: Bool = true) {
        self.titleLabel.text = "\(title) Set"
        self.subtitleLabel.text = subtitles[title] ?? ""
        self.images = images
        coffeeLabel.isHidden = !showCoffeeLabel
        imagesCollectionView.reloadData()
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrimeEmotionImageCell.identifier, for: indexPath) as? PrimeEmotionImageCell else {
            fatalError("Unable to dequeue ImageCell")
        }
        cell.configure(with: images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 140)
    }
   
    private func configureCoffeeLabel(for category: String) {
        coffeeLabel.backgroundColor =  AppColors.color15
        coffeeLabel.textColor = AppColors.color5
        coffeeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        coffeeLabel.layer.cornerRadius = 15
        coffeeLabel.layer.masksToBounds = true
        coffeeLabel.textAlignment = .center
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "coffeebeans")?.withRenderingMode(.alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: -3, width: 18, height: 18)
        let attachmentString = NSAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: " \(category)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        let combinedString = NSMutableAttributedString()
        combinedString.append(attachmentString)
        combinedString.append(textString)
        
        coffeeLabel.attributedText = combinedString
    }
}

import UIKit

class PrimeEmotionImageCell: UICollectionViewCell {
    static let identifier = "PrimeEmotionImageCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let indicatorView: IndicatorView = {
        let view = IndicatorView()
        view.indicatorColor = AppColors.color28
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(indicatorView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            indicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 40),
            indicatorView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with imageUrl: String) {
      
        indicatorView.show()
        imageView.image = nil

       
        if let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                  
                    self.indicatorView.hide()
                    
                    if let data = data, let image = UIImage(data: data) {
                        self.imageView.image = image
                    } else {
                        self.imageView.image = nil
                    }
                }
            }.resume()
        } else {
           
            DispatchQueue.main.async {
                self.indicatorView.hide()
                self.imageView.image = nil
            }
        }
    }
}
