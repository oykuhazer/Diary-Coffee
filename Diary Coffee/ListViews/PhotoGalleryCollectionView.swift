//
//  PhotoGalleryCollectionView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 13.11.2024.
//

import UIKit

extension PhotoGalleryVC: UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sortedKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = sortedKeys[section]
        return groupedPhotos[key]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoGalleryCell", for: indexPath) as? PhotoGalleryCell else {
            return UICollectionViewCell()
        }
        
        let key = sortedKeys[indexPath.section]
        if let photo = groupedPhotos[key]?[indexPath.item] {
            cell.configure(with: photo)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PhotoGalleryDateTitleView", for: indexPath) as? PhotoGalleryDateTitleView else {
                return UICollectionReusableView()
            }
            
            let key = sortedKeys[indexPath.section]
            header.titleLabel.text = key
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = sortedKeys[indexPath.section]
        if let selectedPhoto = groupedPhotos[key]?[indexPath.item] {
            let detailVC = PhotoDetailVC()
            detailVC.documentInfo = selectedPhoto
            
            detailVC.entryDate = journalEntriesResponse?.journalEntriesInfoList?.first(where: { entry in
                entry.coffeeMomentPhotoList.contains(where: { $0.documentGUID == selectedPhoto.documentGUID })
            })?.journalEntryDate
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

