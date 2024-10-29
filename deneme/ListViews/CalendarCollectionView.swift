//
//  CalendarCollectionView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 28.10.2024.
//

import UIKit

extension CalendarVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoffeeDiaryCalendarCell", for: indexPath) as! CoffeeDiaryCalendarCell
        cell.configure(with: "sdfsdfsdfsdfkjsdfksjdfksdjfksdjfksdjfksdjfksdjfksdfjdksjf sdfsjdkfsdkfjsdkfjdsklfjklsdfjlksjfklsdjflksjflksjfskldjfksldjfklsdjfksldjfksldjfksdljfksdlfjklsdfjslkd")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: 500)
    }
}
