//
//  EmotionSetCell.swift
//  DailyCoffee
//
//  Created by Öykü Hazer Ekinci on 10.12.2024.
//


import UIKit

class EmotionSetCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    static let identifier = "EmotionSetCell"
    
    private let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(EmotionImageCell.self, forCellWithReuseIdentifier: EmotionImageCell.identifier)
        return collectionView
    }()
    
    var titleLabel: UILabel = {
       let label = UILabel()
       label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = AppColors.color22
       label.textAlignment = .left
       label.numberOfLines = 1
       return label
       }()
    
    var subtitleLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
           label.textColor = AppColors.color27
           label.textAlignment = .left
           label.numberOfLines = 0
           return label
       }()
    
    private let coffeeLabel: UILabel = UILabel()
    private var images: [String] = []
  
      

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = AppColors.color22
             contentView.layer.cornerRadius = 15
             contentView.layer.masksToBounds = true

             contentView.addSubview(imagesCollectionView)
             contentView.addSubview(titleLabel)
             contentView.addSubview(subtitleLabel)
             contentView.addSubview(coffeeLabel)
             
             imagesCollectionView.delegate = self
             imagesCollectionView.dataSource = self
             imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
             titleLabel.translatesAutoresizingMaskIntoConstraints = false
             subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
             coffeeLabel.translatesAutoresizingMaskIntoConstraints = false
             contentView.clipsToBounds = false
             configureCoffeeLabel(for: "250")
        
        NSLayoutConstraint.activate([
                    imagesCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                    imagesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                    imagesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                    imagesCollectionView.heightAnchor.constraint(equalToConstant: 80),

                    titleLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
                    titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                    titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                    titleLabel.heightAnchor.constraint(equalToConstant: 20),
                    
                    subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
                    subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                    subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                    
                    coffeeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                    coffeeLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
                    coffeeLabel.heightAnchor.constraint(equalToConstant: 30),
                    coffeeLabel.widthAnchor.constraint(equalToConstant: 80)
                ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for index: Int, setName: String? = nil, images: [String], showCoffeeLabel: Bool = true) {
        self.images = images
        
        if let setName = setName {
          
            self.titleLabel.text = setName
                .replacingOccurrences(of: "(\\p{Ll})(\\p{Lu})", with: "$1 $2", options: .regularExpression)
                .replacingOccurrences(of: "(\\D)(\\d)", with: "$1 $2", options: .regularExpression) 
        } else {
            self.titleLabel.text = "Classic Set \(index + 1)"
        }

        
        self.subtitleLabel.text = NSLocalizedString("for_lovers_of_classic_cups", comment: "")
        coffeeLabel.isHidden = !showCoffeeLabel
        imagesCollectionView.reloadData()
    }

  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionImageCell.identifier, for: indexPath) as? EmotionImageCell else {
            fatalError("Unable to dequeue ImageCell")
        }
        cell.configure(with: images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 48)
    }
    
    private func configureCoffeeLabel(for category: String) {
            coffeeLabel.backgroundColor = AppColors.color15
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

class EmotionImageCell: UICollectionViewCell {
    static let identifier = "EmotionImageCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let indicatorView: IndicatorView = {
          let view = IndicatorView()
          view.indicatorColor =  AppColors.color28
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
