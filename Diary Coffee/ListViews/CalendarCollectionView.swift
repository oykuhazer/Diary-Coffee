//
//  CalendarCollectionView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 28.10.2024.
//

import UIKit


extension CalendarVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         
          return journalEntriesResponse?.journalEntriesInfoList?.count ?? 0
      }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoffeeDiaryCalendarCell", for: indexPath) as! CoffeeDiaryCalendarCell
           
          
           if let entry = journalEntriesResponse?.journalEntriesInfoList?[indexPath.item] {
               cell.configure(with: entry)
               cell.delegate = self
           }
           
           return cell
       }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let entry = journalEntriesResponse?.journalEntriesInfoList?[indexPath.item] {
            let tempCell = CoffeeDiaryCalendarCell()
            tempCell.configure(with: entry)
            let calculatedHeight = tempCell.calculateHeight()
            return CGSize(width: collectionView.frame.width - 20, height: calculatedHeight)
        }
        return CGSize(width: collectionView.frame.width - 20, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 30
       }

}
