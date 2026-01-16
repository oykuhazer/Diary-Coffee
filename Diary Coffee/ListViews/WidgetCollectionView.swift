//
//  WidgetCollectionView.swift
//  Diary Coffee
//
//  Created by Öykü Hazer Ekinci on 30.12.2024.
//



import UIKit

extension WidgetsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView == primeCollectionView {
            return matchedSets.count
        } else if collectionView == classicCollectionView {
            return classicMatchedSets.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == primeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrimeEmotionSetCell.identifier, for: indexPath) as? PrimeEmotionSetCell else {
                fatalError("Unable to dequeue PrimeEmotionSetCell")
            }

            let primeEmotionSet = matchedSets[indexPath.item]
            cell.configure(with: primeEmotionSet.setName, images: primeEmotionSet.images, showCoffeeLabel: false)

           
            if indexPath == selectedIndexPath {
                cell.contentView.backgroundColor = AppColors.color14
            } else {
                cell.contentView.backgroundColor = AppColors.color22
            }

            return cell
        } else if collectionView == classicCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionSetCell.identifier, for: indexPath) as? EmotionSetCell else {
                fatalError("Unable to dequeue EmotionSetCell")
            }

            let classicEmotionSet = classicMatchedSets[indexPath.item]
            let setName = classicEmotionSet.setName

            cell.configure(for: indexPath.item, setName: setName, images: classicEmotionSet.images, showCoffeeLabel: false)

            return cell
        }
        
        fatalError("Unexpected collection view")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width - 30, height: 130)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 80
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let previousIndexPath = selectedIndexPath {
            if let previousCell = collectionView.cellForItem(at: previousIndexPath) {
                previousCell.contentView.backgroundColor = AppColors.color22
            }
        }

       
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = AppColors.color14
        }

     
        selectedIndexPath = indexPath

        if collectionView == primeCollectionView {
           
        } else if collectionView == classicCollectionView {
            
        }
    }
}


