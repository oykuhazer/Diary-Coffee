//
//  PhotoGalleryCell.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 13.11.2024.
//

import UIKit

class PhotoGalleryCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with documentInfo: DocumentInfo) {
        if let base64String = documentInfo.base64Data, let imageData = Data(base64Encoded: base64String) {
            imageView.image = UIImage(data: imageData)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
}
