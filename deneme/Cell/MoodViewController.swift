//
//  MoodView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 10.10.2024.
//

import UIKit

class MoodViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var moodCollectionView: UICollectionView?
    var selectedMoodImage: UIImage?
    
    var onMoodSelected: ((UIImage?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMoodViewUI()
    }

    func setupMoodViewUI() {
        // Daha etkileyici arka plan rengi
        view.backgroundColor = UIColor(white: 0, alpha: 0.75)
        
        let moodContainerView = UIView()
        moodContainerView.backgroundColor = .white
        moodContainerView.layer.cornerRadius = 25
        moodContainerView.layer.shadowColor = UIColor.black.cgColor
        moodContainerView.layer.shadowOpacity = 0.4
        moodContainerView.layer.shadowOffset = CGSize(width: 0, height: 7)
        moodContainerView.layer.shadowRadius = 12
        moodContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(moodContainerView)
        
        // Başlık Label
        let titleLabel = UILabel()
        titleLabel.text = "Kahve Modunu Seç"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 26)
        titleLabel.textColor = UIColor(red: 0.35, green: 0.12, blue: 0.15, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        moodContainerView.addSubview(titleLabel)

        // Close Button
        let closeButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold)
        let closeIcon = UIImage(systemName: "xmark.circle.fill", withConfiguration: config)?.withTintColor(UIColor(red: 0.35, green: 0.12, blue: 0.15, alpha: 1.0), renderingMode: .alwaysOriginal)
        closeButton.setImage(closeIcon, for: .normal)
        closeButton.addTarget(self, action: #selector(closeMoodView), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        moodContainerView.addSubview(closeButton)
        
        // Separator
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        moodContainerView.addSubview(separatorView)

        // Koleksiyon arka planı
        let collectionViewBackground = UIView()
        collectionViewBackground.backgroundColor = UIColor(patternImage: UIImage(named: "pattern") ?? UIImage())
        collectionViewBackground.layer.cornerRadius = 12
        collectionViewBackground.translatesAutoresizingMaskIntoConstraints = false
        moodContainerView.addSubview(collectionViewBackground)

        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        // Ekran genişliğini alın ve hesaplamalar yapın
        let screenWidth = UIScreen.main.bounds.width
        let numberOfItemsPerRow: CGFloat = 5
        let spacing: CGFloat = 10
        let totalSpacing = (numberOfItemsPerRow - 1) * spacing // Aradaki boşluklar
        let availableWidth = screenWidth - (2 * spacing) // Sol ve sağdan boşluk
        let itemWidth = (availableWidth - totalSpacing) / numberOfItemsPerRow

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth) // Hücre boyutunu belirleyin
        layout.minimumInteritemSpacing = spacing // Hücreler arası yatay boşluk
        layout.minimumLineSpacing = spacing // Satırlar arası dikey boşluk
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing) // Kenar boşlukları

        moodCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        moodCollectionView!.delegate = self
        moodCollectionView!.dataSource = self
        moodCollectionView!.backgroundColor = .clear
        moodCollectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MoodCell")
        moodCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        moodCollectionView?.showsVerticalScrollIndicator = false
        moodCollectionView?.showsHorizontalScrollIndicator = false
        moodContainerView.addSubview(moodCollectionView!)

        NSLayoutConstraint.activate([
            moodContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            moodContainerView.widthAnchor.constraint(equalToConstant: 380),
            moodContainerView.heightAnchor.constraint(equalToConstant: 430),
            moodContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: moodContainerView.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: moodContainerView.centerXAnchor),
            
            closeButton.topAnchor.constraint(equalTo: moodContainerView.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: moodContainerView.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            
            separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            separatorView.leadingAnchor.constraint(equalTo: moodContainerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: moodContainerView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            collectionViewBackground.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            collectionViewBackground.leadingAnchor.constraint(equalTo: moodContainerView.leadingAnchor, constant: 10),
            collectionViewBackground.trailingAnchor.constraint(equalTo: moodContainerView.trailingAnchor, constant: -10),
            collectionViewBackground.bottomAnchor.constraint(equalTo: moodCollectionView!.bottomAnchor),
            
            moodCollectionView!.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 15),
            moodCollectionView!.leadingAnchor.constraint(equalTo: moodContainerView.leadingAnchor, constant: 10),
            moodCollectionView!.trailingAnchor.constraint(equalTo: moodContainerView.trailingAnchor, constant: -10),
            moodCollectionView!.heightAnchor.constraint(equalToConstant: 330)
        ])
    }

    @objc private func closeMoodView() {
        self.dismiss(animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 45 // Mood seçenek sayısı
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoodCell", for: indexPath)
        
        // Hücre altındaki tüm alt görselleri temizleyin
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        cell.layer.cornerRadius = 10 // Hücrelere köşe yuvarlamaları
        
        let imageView = UIImageView(image: UIImage(named: "\(indexPath.row + 1)"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = cell.contentView.bounds
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        cell.contentView.addSubview(imageView)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = UIImage(named: "\(indexPath.row + 1)")
        onMoodSelected?(selectedImage)
        dismiss(animated: true, completion: nil)
    }
}
