//
//  PhotoGalleryVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 12.11.2024.
//

import UIKit

class PhotoGalleryVC: UIViewController {
    
    var journalEntriesResponse: ListJournalEntriesResponse?
    
    private var collectionView: UICollectionView!
    var groupedPhotos: [String: [DocumentInfo]] = [:]
    var sortedKeys: [String] = []
    private var emptyMessageLabel: UILabel!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.color6
        navigationItem.title = NSLocalizedString("photo_gallery", comment: "")
        
        setupNavigationBar()
        setupCollectionView()
        groupPhotosByMonthAndYear()
        setupEmptyMessageLabel()
        updateEmptyMessageVisibility()
    
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
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = AppColors.color5
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AppColors.color5
        ]
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: "PhotoGalleryCell")
        collectionView.register(PhotoGalleryDateTitleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PhotoGalleryDateTitleView")
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func groupPhotosByMonthAndYear() {
        guard let entries = journalEntriesResponse?.journalEntriesInfoList else { return }
        
        var dateKeys: [(key: String, date: Date)] = []
        
        for entry in entries {
            for photo in entry.coffeeMomentPhotoList {
                let date = entry.journalEntryDate
                if let dateObj = parseDate(date) {
                    let monthYearKey = formatToMonthYearKey(dateObj)
                    
                    if groupedPhotos[monthYearKey] != nil {
                        groupedPhotos[monthYearKey]?.append(photo)
                    } else {
                        groupedPhotos[monthYearKey] = [photo]
                        dateKeys.append((monthYearKey, dateObj))
                    }
                }
            }
        }
        
        sortedKeys = dateKeys.sorted { $0.date > $1.date }.map { $0.key }
    }
    
    private func parseDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
    
    private func formatToMonthYearKey(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func setupEmptyMessageLabel() {
        emptyMessageLabel = UILabel()
        emptyMessageLabel.text = NSLocalizedString("no_photos", comment: "")
        emptyMessageLabel.textColor = AppColors.color5
        emptyMessageLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        emptyMessageLabel.textAlignment = .center
        emptyMessageLabel.numberOfLines = 0
        emptyMessageLabel.isHidden = true
        
        view.addSubview(emptyMessageLabel)
        emptyMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func updateEmptyMessageVisibility() {
        let isEmpty = groupedPhotos.isEmpty
        emptyMessageLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
    }
}
