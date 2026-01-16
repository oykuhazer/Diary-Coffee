//
//  ThemesCollectionView.swift
//  Diary Coffee
//
//  Created by Öykü Hazer Ekinci on 30.12.2024.
//

import Foundation
import UIKit

extension ThemesView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return collectionView == emotionCollectionView ? emotionSets.count : primeEmotionSets.count
      }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == emotionCollectionView {
               
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionSetCell.identifier, for: indexPath) as? EmotionSetCell else {
                    fatalError("Unable to dequeue EmotionSetCell")
                }
                
                let emotionSet = emotionSets[indexPath.item]
               
                cell.configure(for: indexPath.item, images: emotionSet.images)
                return cell
            } else {
               
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrimeEmotionSetCell.identifier, for: indexPath) as? PrimeEmotionSetCell else {
                    fatalError("Unable to dequeue PrimeEmotionSetCell")
                }
                
                let primeEmotionSet = primeEmotionSets[indexPath.item]
              
                cell.configure(with: primeEmotionSet.setName, images: primeEmotionSet.images)
                return cell
            }
        }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let requiredBeans: Int

        if collectionView == primeCollectionView {
            requiredBeans = 300
            guard let cell = collectionView.cellForItem(at: indexPath) as? PrimeEmotionSetCell else {
                return
            }
            
            let title = cell.titleLabel.text?.replacingOccurrences(of: " Set", with: "") ?? "Unknown"
            let fullSubtitle = cell.getSubtitle(for: title) ?? ""
            let description = fullSubtitle.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No description available."
            
            let buyView = BuyView(frame: CGRect(
                x: 0,
                y: 0,
                width: self.bounds.width,
                height: self.bounds.height * 2
            ))
            buyView.center = self.center
            buyView.configure(title: "\(title) Set", description: description, requiredBeans: requiredBeans)
            showBuyView(buyView)
        } else if collectionView == emotionCollectionView {
            requiredBeans = 250
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmotionSetCell else {
                return
            }
            
            let title = cell.titleLabel.text ?? "Classic Set \(indexPath.item + 1)"
            let description = cell.subtitleLabel.text ?? NSLocalizedString("for_lovers_of_classic_cups", comment: "")

            
            let buyView = BuyView(frame: CGRect(
                x: 0,
                y: 0,
                width: self.bounds.width,
                height: self.bounds.height * 2
            ))
            buyView.center = self.center
            buyView.configure(title: title, description: description, requiredBeans: requiredBeans)
            showBuyView(buyView)
        }
    }


    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 30 
        return CGSize(width: width, height: 120)
    }
}
