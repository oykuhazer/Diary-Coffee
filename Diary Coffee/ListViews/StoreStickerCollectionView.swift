//
//  StoreStickerCollectionView.swift
//  Diary Coffee
//
//  Created by Öykü Hazer Ekinci on 30.12.2024.
//

import Foundation
import UIKit

extension StoreStickerView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = categories[collectionView.tag]
        return stickers[category]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let category = categories[safe: collectionView.tag],
              let stickerURLs = stickers[category] else {
           
            return UICollectionViewCell()
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
        ])

        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .medium)
        imageView.image = UIImage(systemName: "photo.fill", withConfiguration: config)
        imageView.tintColor = AppColors.color23

        if indexPath.item < stickerURLs.count {
            let stickerURLString = stickerURLs[indexPath.item]
            downloadImage(from: stickerURLString) { image in
                DispatchQueue.main.async {
                   
                    if collectionView.indexPath(for: cell) == indexPath {
                        imageView.image = image
                    }
                }
            }
        }

        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[collectionView.tag]
        let fullDescription = descriptions[category] ?? ""
        
        let requiredBeans = 350
        
        let buyView = BuyView(frame: CGRect(
            x: 0,
            y: 0,
            width: self.bounds.width,
            height: self.bounds.height * 2
        ))
        buyView.center = self.center
    
        let isFromStoreStickerView = true
        
        buyView.configure(
            title: category,
            description: fullDescription,
            requiredBeans: requiredBeans,
            isFromStoreStickerView: isFromStoreStickerView
        )
        
        showBuyView(buyView)
    }
    }
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
