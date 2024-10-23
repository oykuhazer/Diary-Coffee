//
//  CoffeeAnalysisDetailTableView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 19.10.2024.
//

import Foundation
import UIKit

extension AnalysisDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMomentTypeFlag {
            return coffeeMoments.count
        } else if isCoffeeTypeFlag {
            return coffeeTypes.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeAnalysisDetailCell", for: indexPath) as! CoffeeAnalysisDetailCell
        let rowNumber = indexPath.row + 1
        
        if isMomentTypeFlag {
            // Moment verilerini göster
            cell.configure(with: coffeeMomentsImageNames[indexPath.row], rowNumber: rowNumber, momentText: coffeeMoments[indexPath.row], countText: momentCounts[indexPath.row])
        } else if isCoffeeTypeFlag {
            // Coffee type verilerini göster
            cell.configure(with: coffeeTypeImageNames[indexPath.row], rowNumber: rowNumber, momentText: coffeeTypes[indexPath.row], countText: coffeeTypeCounts[indexPath.row])
        }

        // İlk üç sıra belirgin, diğerleri daha soluk renkte olacak
        if rowNumber <= 3 {
            cell.rowLabel.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0) // Belirgin kahve tonu
        } else {
            cell.rowLabel.textColor = UIColor(red: 0.6, green: 0.5, blue: 0.4, alpha: 1.0) // Daha pasif renk
        }
        
        cell.selectionStyle = .none
        return cell
    }

    
    
    // Hücre yüksekliğini ayarlamak için
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // Hücre yüksekliği azaltıldı
    }

    // Hücre tıklamasını devre dışı bırakıyoruz
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Bu işlev boş bırakılarak hücre tıklamaları devre dışı bırakılıyor
    }
}
