//
//  OnBoardingStillCollectionView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 25.10.2024.
//

import Foundation
import UIKit

extension StillSelectionVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12 // 12 farklı resim seti
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StillImageGroupCell.identifier, for: indexPath) as! StillImageGroupCell

        switch indexPath.item {
        case 0:
            cell.images = StillImageGroupCell.imagesSet1
        case 1:
            cell.images = StillImageGroupCell.imagesSet2
        case 2:
            cell.images = StillImageGroupCell.imagesSet3
        case 3:
            cell.images = StillImageGroupCell.imagesSet4
        case 4:
            cell.images = StillImageGroupCell.imagesSet5
        case 5:
            cell.images = StillImageGroupCell.imagesSet6
        case 6:
            cell.images = StillImageGroupCell.imagesSet7
        case 7:
            cell.images = StillImageGroupCell.imagesSet8
        case 8:
            cell.images = StillImageGroupCell.imagesSet9
        case 9:
            cell.images = StillImageGroupCell.imagesSet10
        case 10:
            cell.images = StillImageGroupCell.imagesSet11
        case 11:
            cell.images = StillImageGroupCell.imagesSet12
        default:
            cell.images = []
        }

        return cell
    }
    
    
}
