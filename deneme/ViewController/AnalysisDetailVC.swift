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
    
    let coffeeTypes = ["Espresso","Americano","Cappuccino", "Latte", "Mocha", "Macchiato", "Ristretto", "Affogato", "Turkish Coffee", "Irish Coffee", "Vienna Coffee", "Cold Brew", "Frappé", "Café de Olla", "Lungo", "Mazagran", "Shakerato", "Romano", "Breve Coffee"]
    
    let coffeeMoments = ["Sabah", "Öğleden Sonra", "Akşamüstü",
                             "Kitap Okurken", "Romantik", "Tatlıyla Beraber", "İlham",
                             "Kamp", "Seyahat", "Sohbet", "Arkadaşlarla", "İş Molası"]
        
        let momentCounts = ["x2", "x5", "x3", "x7", "x1", "x4", "x3", "x2", "x6", "x1", "x2", "x4"]
        
    let coffeeMomentCounts = ["x2", "x5", "x3", "x7", "x1", "x4", "x3", "x2", "x6", "x1", "x2", "x4"]
    
    let coffeeTypeCounts = ["x2", "x5", "x3", "x7", "x1", "x4", "x3", "x2", "x6", "x1", "x2", "x4", "x4", "x3", "x2", "x6", "x1", "x2", "x4"]
    
        let coffeeMomentsImageNames = ["breakfast", "afternoon", "evening", "reading", "loving", "dessert", "inspiration", "camp", "trip", "chat", "friends", "workbreak"]

    let coffeeTypeImageNames = ["espresso","americano","cappuccino", "latte", "mocha", "macchiato", "ristretto", "affogato", "turkish", "irish", "vienna", "cold brew", "frappe", "café de olla", "lungo", "mazagran", "shakerato", "romano", "breve"]

    // TableView oluşturuyoruz
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Ekran arka plan rengini ayarlıyoruz
        let backgroundColor = UIColor(red: 0.4, green: 0.3, blue: 0.25, alpha: 1.0)
        view.backgroundColor = backgroundColor
        
        navigationItem.title = "Frequently Recorded"
          
          // Back butonu özelleştirilerek sadece '<' simgesi görünecek
          let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
          navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
          
          // Back butonu rengini sayfaya uygun hale getiriyoruz (kahve tonları)
          navigationController?.navigationBar.tintColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)
          
          // Başlık rengini ayarlıyoruz
          let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)]
          navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        
        // Sol üst köşeye buton eklemek için
        let mostRecordsButton = UIButton(type: .system)
           mostRecordsButton.setTitle("Most Records", for: .normal)
           
           // Küçültülmüş bir aşağı ok simgesi oluşturuyoruz
           let arrowDown = UIImage(systemName: "chevron.down")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12, weight: .medium))
           mostRecordsButton.setImage(arrowDown, for: .normal)
           
           // Kenarlık ekliyoruz
           mostRecordsButton.layer.borderColor = UIColor(red: 0.9, green: 0.85, blue: 0.8, alpha: 1.0).cgColor // Kahve tonunda kenarlık rengi
           mostRecordsButton.layer.borderWidth = 2
           mostRecordsButton.layer.cornerRadius = 8
           mostRecordsButton.layer.masksToBounds = true
           
           // Buton yazı ve simge renklerini TableView'deki renklere uyarlıyoruz
           mostRecordsButton.setTitleColor(UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0), for: .normal) // Yazı rengi (kahve tonu)
           mostRecordsButton.tintColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0) // Ok işareti rengi
           
           mostRecordsButton.semanticContentAttribute = .forceRightToLeft
           mostRecordsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
           mostRecordsButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)

           // Butonun arka plan rengini ayarlıyoruz
           mostRecordsButton.backgroundColor = UIColor(red: 0.45, green: 0.35, blue: 0.3, alpha: 1.0)
           
           // Butonu view'e ekleyip constraint'lerini ayarlıyoruz
           mostRecordsButton.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(mostRecordsButton)
           
           NSLayoutConstraint.activate([
               mostRecordsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
               mostRecordsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
               mostRecordsButton.widthAnchor.constraint(equalToConstant: 180),
               mostRecordsButton.heightAnchor.constraint(equalToConstant: 40)
           ])
        
        // SortByView açma aksiyonu
        mostRecordsButton.addTarget(self, action: #selector(openSortByView), for: .touchUpInside)
        
        // TableView ayarları
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CoffeeAnalysisDetailCell.self, forCellReuseIdentifier: "CoffeeAnalysisDetailCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // TableView'in arka plan rengini ekranın arka plan renginden daha açık yapıyoruz
        tableView.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)
        
        // Separator çizgilerini kaldırıyoruz
        tableView.separatorStyle = .none
        
        // Scroll çubuğunu kaldırıyoruz
        tableView.showsVerticalScrollIndicator = false
        
        // TableView kenarlarına radius ekliyoruz
        tableView.layer.cornerRadius = 20
        tableView.clipsToBounds = true
        
        // TableView Constraints (20 birim sağdan ve soldan, 50 birim yukarıdan ve aşağıdan boşluk)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mostRecordsButton.bottomAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // SortByView'i açan fonksiyon
    @objc func openSortByView() {
        let sortByVC = SortByView() // SortByView oluşturulmuş sınıfı
        sortByVC.modalPresentationStyle = .overCurrentContext
        sortByVC.modalTransitionStyle = .crossDissolve
        present(sortByVC, animated: true, completion: nil)
    }
    
}
