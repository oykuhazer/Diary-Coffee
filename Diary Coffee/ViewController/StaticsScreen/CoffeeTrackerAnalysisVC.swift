//
//  CoffeeTrackerAnalysisVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 10.11.2024.
//

import UIKit

class CoffeeTrackerAnalysisVC: UIViewController {

    var selectedYear: Int?
    var dates: [String] = []
    private let yearView = CoffeeTrackerYearView()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let selectedYear = selectedYear {
                   yearView.setYearLabel(year: selectedYear)
               }

      yearView.setupEntireYearView(with: dates)
        
        let safeAreaBackgroundView = CustomSafeAreaBackgroundView(backgroundColor: AppColors.color6)
        view.addSubview(safeAreaBackgroundView)
        view.sendSubviewToBack(safeAreaBackgroundView)
        
        view.backgroundColor = AppColors.color6
        
        navigationItem.title = NSLocalizedString("a_year_gone_with_coffee", comment: "")

        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = AppColors.color5
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppColors.color5]
        
        navigationController?.navigationBar.backgroundColor = AppColors.color6
      
        let scrollView = UIScrollView()
        scrollView.backgroundColor = AppColors.color6
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
       
        let containerView = UIView()
        containerView.backgroundColor = AppColors.color6
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
       
        addBottomBorder(to: containerView)

        yearView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(yearView)
        
        NSLayoutConstraint.activate([
            yearView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            yearView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            yearView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            yearView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -80)
        ])
 
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? CustomTabBarController {
        
            tabBarController.tabBar.isHidden = true
            tabBarController.tabBar.isUserInteractionEnabled = false
            tabBarController.tabBar.items?.forEach { $0.isEnabled = false }
            tabBarController.circularView.isHidden = true
            tabBarController.circularView.isUserInteractionEnabled = false
            
        
            if let gestures = tabBarController.circularView.gestureRecognizers {
                gestures.forEach { tabBarController.circularView.removeGestureRecognizer($0) }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? CustomTabBarController {
           
            tabBarController.tabBar.isHidden = false
            tabBarController.tabBar.isUserInteractionEnabled = true
            tabBarController.tabBar.items?.forEach { $0.isEnabled = true }

            tabBarController.circularView.isHidden = false
            tabBarController.circularView.isUserInteractionEnabled = true
            
           
            let tapGesture = UITapGestureRecognizer(target: tabBarController, action: #selector(tabBarController.circularViewTapped))
            tabBarController.circularView.addGestureRecognizer(tapGesture)
        }
    }


  
    private func addBottomBorder(to containerView: UIView) {
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = AppColors.color5
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bottomBorder)
        
        NSLayoutConstraint.activate([
            bottomBorder.heightAnchor.constraint(equalToConstant: 1),
            bottomBorder.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomBorder.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ])
    }
}

