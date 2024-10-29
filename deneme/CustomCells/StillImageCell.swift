//
//  StillImageCell.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 26.10.2024.
//

import Foundation
import UIKit

class StillImageCell: UICollectionViewCell {
    static let identifier = "StillImageCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.backgroundColor = UIColor(red: 0.92, green: 0.88, blue: 0.82, alpha: 1.0) // Bir ton daha koyu bej rengi
        contentView.layer.cornerRadius = 8 // Radius ekle
        contentView.clipsToBounds = true // Köşe taşıp taşmaması için
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: UIImage?) {
        imageView.image = image
    }
}
