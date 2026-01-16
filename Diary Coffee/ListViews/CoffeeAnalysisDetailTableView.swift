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
        return getSortedCounts().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeAnalysisDetailCell", for: indexPath) as! CoffeeAnalysisDetailCell
        let sortedCounts = getSortedCounts()
        let item = sortedCounts[indexPath.row]
        
      
        cell.configure(with: item.key, rowNumber: indexPath.row + 1, momentText: item.key, countText: "x\(item.value)")
        
       
        if indexPath.row < 3 {
            cell.rowLabel.textColor = AppColors.color5
        } else {
            cell.rowLabel.textColor = AppColors.color11
        }
        
      
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 
    }
}

