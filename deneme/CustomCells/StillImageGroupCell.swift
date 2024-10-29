//
//  StillImageGroupCell.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 26.10.2024.
//

import Foundation
import UIKit

class StillImageGroupCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    static let identifier = "StillImageGroupCell"
    
    private let innerCollectionView: UICollectionView
    
  
    static let imagesSet1 = ["4-1-1", "4-2-1", "4-3-1", "4-4-1", "4-5-1", "4-6-1"]
    static let imagesSet2 = ["4-1-2", "4-2-2", "4-3-2", "4-4-2", "4-5-2", "4-6-2"]
    static let imagesSet3 = ["4-1-3", "4-2-3", "4-3-3", "4-4-3", "4-5-3", "4-6-3"]
    static let imagesSet4 = ["5-1-1", "5-2-1", "5-3-1", "5-4-1", "5-5-1", "5-6-1"]
    static let imagesSet5 = ["5-1-2", "5-2-2", "5-3-2", "5-4-2", "5-5-2", "5-6-2"]
    static let imagesSet6 = ["5-1-3", "5-2-3", "5-3-3", "5-4-3", "5-5-3", "5-6-3"]
    static let imagesSet7 = ["6-1-1", "6-2-1", "6-3-1", "6-4-1", "6-5-1", "6-6-1"]
    static let imagesSet8 = ["6-1-2", "6-2-2", "6-3-2", "6-4-2", "6-5-2", "6-6-2"]
    static let imagesSet9 = ["6-1-3", "6-2-3", "6-3-3", "6-4-3", "6-5-3", "6-6-3"]
    static let imagesSet10 = ["1-1-1", "1-2-1", "1-3-1", "1-4-1", "1-5-1", "1-6-1"]
    static let imagesSet11 = ["1-1-2", "1-2-2", "1-3-2", "1-4-2", "1-5-2", "1-6-2"]
    static let imagesSet12 = ["1-1-3", "1-2-3", "1-3-3", "1-4-3", "1-5-3", "1-6-3"]
    
    var images: [String] = [] {
        didSet {
            innerCollectionView.reloadData()
        }
    }
    private static var selectedCell: StillImageGroupCell?
    override init(frame: CGRect) {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           layout.itemSize = CGSize(width: 50, height: 50)
           layout.minimumLineSpacing = 10
           layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
           innerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
           
           super.init(frame: frame)
           
           innerCollectionView.translatesAutoresizingMaskIntoConstraints = false
           innerCollectionView.register(StillImageCell.self, forCellWithReuseIdentifier: StillImageCell.identifier)
           innerCollectionView.dataSource = self
           innerCollectionView.delegate = self
           innerCollectionView.backgroundColor = .clear
           innerCollectionView.showsHorizontalScrollIndicator = false
           innerCollectionView.showsVerticalScrollIndicator = false
           contentView.addSubview(innerCollectionView)
           
           contentView.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
           contentView.layer.cornerRadius = 12
           contentView.clipsToBounds = true
           
           NSLayoutConstraint.activate([
               innerCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
               innerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
               innerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
               innerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
           ])
       }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       override func prepareForReuse() {
           super.prepareForReuse()
           // Hücre yeniden kullanıldığında varsayılan arka plan rengine dön
           contentView.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
       }

       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return images.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StillImageCell.identifier, for: indexPath) as! StillImageCell
           let imageName = images[indexPath.item]
           cell.configure(with: UIImage(named: imageName))
           return cell
       }

       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           // Önceki seçimi kaldır
           StillImageGroupCell.selectedCell?.contentView.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
           
           // Yeni seçili cellin contentView rengini değiştir
           contentView.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
           
           // Seçili celli güncelle
           StillImageGroupCell.selectedCell = self
       }
   }


