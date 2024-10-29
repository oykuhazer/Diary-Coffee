//
//  CoffeeAnalysisViewController.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 13.10.2024.
//

import Foundation
import UIKit

class AnalysisVC: UIViewController, MomentStatusViewDelegate, CoffeeStatusViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = UIScrollView()
        let contentView = UIView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        scrollView.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        // Farklı view'ler oluşturuluyor
        let coffeeDailyStatusView = CoffeeDailyStatusView()
        let moodStatusView = MoodStatusView()
        let momentStatusView = MomentStatusView()
        momentStatusView.delegate = self
        let coffeeStatusView = CoffeeStatusView()
        coffeeStatusView.delegate = self
        let coffeeStatusByMoodView = CoffeeStatusByMood()
      
        // Autolayout için translatesAutoresizingMaskIntoConstraints kapatılıyor
        coffeeDailyStatusView.translatesAutoresizingMaskIntoConstraints = false
        moodStatusView.translatesAutoresizingMaskIntoConstraints = false
        momentStatusView.translatesAutoresizingMaskIntoConstraints = false
        coffeeStatusView.translatesAutoresizingMaskIntoConstraints = false
        coffeeStatusByMoodView.translatesAutoresizingMaskIntoConstraints = false
        
        // contentView'e alt view'ler ekleniyor
        contentView.addSubview(coffeeDailyStatusView)
        contentView.addSubview(moodStatusView)
        contentView.addSubview(momentStatusView)
        contentView.addSubview(coffeeStatusView)
        contentView.addSubview(coffeeStatusByMoodView)
        
        // ScrollView ve ContentView için Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // İçeriğin yatay olarak kaymaması için
        ])
        
        // CoffeeDailyStatusView için Constraints
        NSLayoutConstraint.activate([
            coffeeDailyStatusView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            coffeeDailyStatusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            coffeeDailyStatusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            coffeeDailyStatusView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        // MoodStatusView için Constraints (CoffeeDailyStatusView'in altına yerleştirilecek)
        NSLayoutConstraint.activate([
            moodStatusView.topAnchor.constraint(equalTo: coffeeDailyStatusView.bottomAnchor, constant: 20),
            moodStatusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            moodStatusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            moodStatusView.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        // MomentStatsView için Constraints (MoodStatusView'in altına yerleştirilecek)
        NSLayoutConstraint.activate([
            momentStatusView.topAnchor.constraint(equalTo: moodStatusView.bottomAnchor, constant: 20),
            momentStatusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            momentStatusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            momentStatusView.heightAnchor.constraint(equalToConstant: 330)
        ])
        
        // CoffeeStatusView için Constraints (MomentStatsView'in altına yerleştirilecek)
        NSLayoutConstraint.activate([
            coffeeStatusView.topAnchor.constraint(equalTo: momentStatusView.bottomAnchor, constant: 20),
            coffeeStatusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            coffeeStatusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            coffeeStatusView.heightAnchor.constraint(equalToConstant: 330)
        ])
        
        // CoffeeStatusByMood için Constraints (CoffeeStatusView'in altına yerleştirilecek)
        NSLayoutConstraint.activate([
            coffeeStatusByMoodView.topAnchor.constraint(equalTo: coffeeStatusView.bottomAnchor, constant: 20),
            coffeeStatusByMoodView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            coffeeStatusByMoodView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            coffeeStatusByMoodView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20), // İçeriğin altında boşluk
            coffeeStatusByMoodView.heightAnchor.constraint(equalToConstant: 370)
        ])
    }
    
    func didTapMomentMoreButton() {
        let detailVC = AnalysisDetailVC()
        detailVC.isMomentTypeFlag = true
        detailVC.isCoffeeTypeFlag = false
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func didTapCoffeeMoreButton() {
        let detailVC = AnalysisDetailVC()
        detailVC.isMomentTypeFlag = false
        detailVC.isCoffeeTypeFlag = true
        navigationController?.pushViewController(detailVC, animated: true)
    }

   
}
