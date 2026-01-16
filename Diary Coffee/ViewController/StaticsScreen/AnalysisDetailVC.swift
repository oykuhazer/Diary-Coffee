//
//  CoffeeAnalysisDetailViewController.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 19.10.2024.
//

import UIKit

class AnalysisDetailVC: UIViewController {

    
    var isMomentTypeFlag: Bool = false
    var isCoffeeTypeFlag: Bool = false
    var journalEntries: [JournalEntryInfo] = []

    let tableView = UITableView()
    let mostRecordsButton = UIButton(type: .system)
    var isLeastOrder = false
   
    let momentStatusView = MomentStatusView()
    let coffeeStatusView = CoffeeStatusView()
    
     var momentCounts: [String: Int] = [:]
    var coffeeTypeCounts: [String: Int] = [:]
    
   
    var sortedMomentCounts: [(key: String, value: Int)] {
        return getCompleteMomentCounts().sorted { isLeastOrder ? $0.value < $1.value : $0.value > $1.value }
    }

    var sortedCoffeeTypeCounts: [(key: String, value: Int)] {
        return getCompleteCoffeeTypeCounts().sorted { isLeastOrder ? $0.value < $1.value : $0.value > $1.value }
    }
    
    let allCoffeeTypes = [
         ("Espresso", "Espresso"),
         ("Americano", "Americano"),
         ("Cappuccino", "Cappuccino"),
         ("Latte", "Latte"),
         ("Mocha", "Mocha"),
         ("Macchiato", "Macchiato"),
         ("Ristretto", "Ristretto"),
         ("Affogato", "Affogato"),
         ("Turkish Coffee", "Turkish Coffee"),
         ("Irish Coffee", "Irish Coffee"),
         ("Vienna Coffee", "Vienna Coffee"),
         ("Cold Brew", "Cold Brew"),
         ("Frappé", "Frappé"),
         ("Café de Olla", "Café de Olla"),
         ("Lungo", "Lungo"),
         ("Mazagran", "Mazagran"),
         ("Shakerato", "Shakerato"),
         ("Romano", "Romano"),
         ("Breve Coffee", "Breve Coffee")
     ]
     
     let allMoments = [
         ("Morning", "Morning"),
         ("Camp", "Camp"),
         ("Chat", "Chat"),
         ("Dessert", "Dessert"),
         ("Evening", "Evening"),
         ("Afternoon", "Afternoon"),
         ("Friends", "Friends"),
         ("Inspiration", "Inspiration"),
         ("Romantic", "Romantic"),
         ("Reading", "Reading"),
         ("Trip", "Trip"),
         ("Work Break", "Work Break")
     ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.color6
        
        navigationItem.title = NSLocalizedString("frequently_recorded", comment: "")

        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = AppColors.color5
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppColors.color5]

        setupMostRecordsButton()
        setupTableView()
        
      
        configureViewsWithEntries()
        calculateCounts()
        
    }
  
    func getSortedCounts() -> [(key: String, value: Int)] {
        if isMomentTypeFlag {
            return getCompleteMomentCounts().sorted { isLeastOrder ? $0.value < $1.value : $0.value > $1.value }
        } else if isCoffeeTypeFlag {
            return getCompleteCoffeeTypeCounts().sorted { isLeastOrder ? $0.value < $1.value : $0.value > $1.value }
        }
        return []
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
    
    func reloadTableViewData() {
        tableView.reloadData()
    }
    
   

    private func setupMostRecordsButton() {
        
        mostRecordsButton.setTitle(NSLocalizedString("most_records", comment: ""), for: .normal)

        let arrowDown = UIImage(systemName: "chevron.down")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12, weight: .medium))
        mostRecordsButton.setImage(arrowDown, for: .normal)
        mostRecordsButton.layer.borderColor = AppColors.color7.cgColor
        mostRecordsButton.layer.borderWidth = 2
        mostRecordsButton.layer.cornerRadius = 8
        mostRecordsButton.layer.masksToBounds = true
        mostRecordsButton.setTitleColor(AppColors.color5, for: .normal)
        mostRecordsButton.tintColor = AppColors.color5
        mostRecordsButton.semanticContentAttribute = .forceRightToLeft
        mostRecordsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        mostRecordsButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        mostRecordsButton.backgroundColor = AppColors.color8
        mostRecordsButton.translatesAutoresizingMaskIntoConstraints = false
        mostRecordsButton.addTarget(self, action: #selector(openSortByView), for: .touchUpInside)
        view.addSubview(mostRecordsButton)
        
        NSLayoutConstraint.activate([
            mostRecordsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            mostRecordsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mostRecordsButton.widthAnchor.constraint(equalToConstant: 180),
            mostRecordsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CoffeeAnalysisDetailCell.self, forCellReuseIdentifier: "CoffeeAnalysisDetailCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = AppColors.color1
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 20
        tableView.clipsToBounds = true
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mostRecordsButton.bottomAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc func openSortByView() {
        let sortByVC = SortByView()
        sortByVC.modalPresentationStyle = .overCurrentContext
        sortByVC.modalTransitionStyle = .crossDissolve
        
        sortByVC.sortCompletion = { [weak self] isLeastOrder in
            self?.isLeastOrder = isLeastOrder
            self?.updateSortButtonTitle()
            self?.tableView.reloadData()
        }
        
        present(sortByVC, animated: true, completion: nil)
    }
    
    private func configureViewsWithEntries() {
      
        if isMomentTypeFlag {
            momentStatusView.configureWithEntries(journalEntries)
        } else if isCoffeeTypeFlag {
            coffeeStatusView.configureWithEntries(journalEntries)
        }
        
        
        tableView.reloadData()
    }
    
    
    private func calculateCounts() {
       
        for entry in journalEntries {
            let momentType = entry.coffeeMomentType
            momentCounts[momentType, default: 0] += 1

            let coffeeType = entry.coffeeType
            coffeeTypeCounts[coffeeType, default: 0] += 1
        }
    }
     func getCompleteCoffeeTypeCounts() -> [String: Int] {
          var completeCounts = coffeeTypeCounts
          for (type, _) in allCoffeeTypes {
              completeCounts[type, default: 0] = completeCounts[type] ?? 0
          }
          return completeCounts
      }
      
        func getCompleteMomentCounts() -> [String: Int] {
          var completeCounts = momentCounts
          for (moment, _) in allMoments {
              completeCounts[moment, default: 0] = completeCounts[moment] ?? 0
          }
          return completeCounts
      }
    
    func updateSortButtonTitle() {
        if isLeastOrder {
            mostRecordsButton.setTitle(NSLocalizedString("least_records", comment: ""), for: .normal)
        } else {
            mostRecordsButton.setTitle(NSLocalizedString("most_records", comment: ""), for: .normal)
        }
    }

}


