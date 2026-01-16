//
//  WidgetsVC.swift
//  Diary Coffee
//
//  Created by Öykü Hazer Ekinci on 26.12.2024.
//

import UIKit
import Alamofire

class WidgetsVC: UIViewController {

   
    var userProfile: GetUserProfileInformationResponse?
    var matchedSets: [PrimeEmotionSet] = []
    var classicMatchedSets: [EmotionSet] = []
    var selectedIndexPath: IndexPath?
    private var buyButton: UIButton!
    
    private let specialThemeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("special_theme", comment: ""), for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let classicThemeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("classic_theme", comment: ""), for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

     var selectedButton: UIButton?

     var primeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PrimeEmotionSetCell.self, forCellWithReuseIdentifier: PrimeEmotionSetCell.identifier)
        collectionView.backgroundColor = AppColors.color6
        return collectionView
    }()
    
    var classicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EmotionSetCell.self, forCellWithReuseIdentifier: EmotionSetCell.identifier)
        collectionView.backgroundColor = AppColors.color6
        return collectionView
    }()

    
    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("apply", comment: ""), for: .normal)
        button.backgroundColor = AppColors.color2
        button.setTitleColor(AppColors.color3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.color6
        navigationItem.title = NSLocalizedString("widgets", comment: "")
        
        setupNavigationBar()
        setupButtons()
        setupPrimeCollectionView()
        setupClassicCollectionView()
        setupApplyButton()
        setupBuyButton()
        selectButton(specialThemeButton)
        buttonTapped(specialThemeButton)
        
    }


    private func setupBuyButton() {
           buyButton = UIButton(type: .system)
           buyButton.setTitle(NSLocalizedString("purchase", comment: ""), for: .normal)
           buyButton.backgroundColor = AppColors.color2
           buyButton.setTitleColor(AppColors.color3, for: .normal)
           buyButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
           buyButton.layer.cornerRadius = 10
           buyButton.translatesAutoresizingMaskIntoConstraints = false
           buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
           
           view.addSubview(buyButton)

        NSLayoutConstraint.activate([
            buyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 20),
            buyButton.widthAnchor.constraint(equalToConstant: 140),
            buyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        updateBuyButtonVisibility()
       }

       private func updateBuyButtonVisibility() {
           if primeCollectionView.isHidden {
               buyButton.isHidden = !classicMatchedSets.isEmpty
           } else {
               buyButton.isHidden = !matchedSets.isEmpty
           }
       }

     @objc private func buyButtonTapped() {
         if let parentViewController = self.parent {
             parentViewController.dismiss(animated: true) {
                 if let customTabBarController = UIApplication.shared.windows.first?.rootViewController as? CustomTabBarController {
                     customTabBarController.selectedIndex = 2
                 }
             }
         }
     }
    
    private func setupButtons() {
        let buttonStackView = UIStackView(arrangedSubviews: [specialThemeButton, classicThemeButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(buttonStackView)

        specialThemeButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        classicThemeButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            specialThemeButton.heightAnchor.constraint(equalToConstant: 40),
            classicThemeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupPrimeCollectionView() {
        view.addSubview(primeCollectionView)
        primeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        primeCollectionView.dataSource = self
        primeCollectionView.delegate = self

        primeCollectionView.showsVerticalScrollIndicator = false
           primeCollectionView.showsHorizontalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            primeCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            primeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            primeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            primeCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    
    }

    private func setupClassicCollectionView() {
        view.addSubview(classicCollectionView)
        classicCollectionView.translatesAutoresizingMaskIntoConstraints = false
        classicCollectionView.dataSource = self
        classicCollectionView.delegate = self

        classicCollectionView.showsVerticalScrollIndicator = false
           classicCollectionView.showsHorizontalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            classicCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            classicCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            classicCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            classicCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    
    }
    
    
    private func setupApplyButton() {
        view.addSubview(applyButton)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func applyButtonTapped() {
        guard let selectedIndexPath = selectedIndexPath else {
            return
        }

        let selectedSetName: String
        let selectedImages: [String]

        if primeCollectionView.isHidden == false {
            selectedSetName = matchedSets[selectedIndexPath.row].setName
            selectedImages = matchedSets[selectedIndexPath.row].images
        } else if classicCollectionView.isHidden == false {
            selectedSetName = classicMatchedSets[selectedIndexPath.row].setName
            selectedImages = classicMatchedSets[selectedIndexPath.row].images
        } else {
            return
        }
        
        let finalSetName: String
        if selectedSetName.contains("Classic") {
            finalSetName = selectedSetName.replacingOccurrences(of: " ", with: "")
        } else {
            finalSetName = selectedSetName
        }

        UserProfile.shared.styleSelection = finalSetName

        SaveUserProfileRequest.shared.saveUserProfile(in: self.view) { result in
            switch result {
            case .success:
                let recordActionView = RequiredActionView(frame: self.view.bounds)
                recordActionView.configure(
                    icon: UIImage(named: "success"),
                    message: NSLocalizedString("widget_changed_successfully", comment: "")
                )
                self.view.addSubview(recordActionView)

                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    recordActionView.removeFromSuperview()
                }

            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func selectButton(_ button: UIButton) {
        [specialThemeButton, classicThemeButton].forEach {
            $0.backgroundColor = AppColors.color13
            $0.setTitleColor(AppColors.color14, for: .normal)
        }

        button.backgroundColor = AppColors.color14
        button.setTitleColor(AppColors.color13, for: .normal)

        selectedButton = button
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        selectButton(sender)
        
        if sender == specialThemeButton {
          
            primeCollectionView.isHidden = false
            classicCollectionView.isHidden = true
            fetchPrimeEmotionSet()
        } else if sender == classicThemeButton {
           
            primeCollectionView.isHidden = true
            classicCollectionView.isHidden = false
            fetchEmotionSet()
        }
        updateBuyButtonVisibility()
    }


    func fetchPrimeEmotionSet() {
        guard let userProfileInfo = userProfile?.userProfileInfo else {
            
            return
        }

        let emotionCategories = userProfileInfo.purchasedFeatures?.emotions.compactMap { $0.category.split(separator: " ").first.map(String.init) } ?? []

        guard !emotionCategories.isEmpty else {
            
            return
        }

        let loadingView = LoadingView(frame: view.bounds)
        view.addSubview(loadingView)

        PrimeEmotionSetRequest.shared.uploadPrimeEmotionSet(primeEmotionSet: "", in: view) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                loadingView.isHidden = true

                guard response.resultCode == 200 else {
                   
                    return
                }

                let targetOrder = ["smile", "kissing", "wow", "sleep", "sad", "angry"]

                self.matchedSets = response.primeEmotionSets!.compactMap { primeEmotionSet in
                    guard emotionCategories.contains(primeEmotionSet.setName) else { return nil }

                    let sortedImages = primeEmotionSet.images.sorted { image1, image2 in
                        let name1 = image1.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
                        let name2 = image2.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
                        let index1 = targetOrder.firstIndex(of: name1) ?? Int.max
                        let index2 = targetOrder.firstIndex(of: name2) ?? Int.max
                        return index1 < index2
                    }

                    return PrimeEmotionSet(setName: primeEmotionSet.setName, images: sortedImages)
                }

                self.primeCollectionView.reloadData()

            case .failure(let error):
                loadingView.isHidden = true
               
            }
            
            self.updateBuyButtonVisibility()
        }
    }

    func fetchEmotionSet() {
        guard let userProfileInfo = userProfile?.userProfileInfo else {
            return
        }

        let classicCategories = userProfileInfo.purchasedFeatures?.emotions
            .compactMap { $0.category.contains("ClassicSet") ? $0.category : nil } ?? []

        guard !classicCategories.isEmpty else {
            return
        }

        let loadingView = LoadingView(frame: view.bounds)
        view.addSubview(loadingView)

        let emotionSetParameter = ""

        EmotionSetRequest.shared.uploadEmotionSet(emotionSet: emotionSetParameter) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                loadingView.isHidden = true

                guard response.resultCode == 200 else {
                    return
                }

                let targetOrder = ["smile", "kissing", "wow", "sleep", "sad", "angry"]

                let matchedSets = (response.emotionSets ?? []).filter { emotionSet in
                    return classicCategories.contains(emotionSet.setName)
                }.map { emotionSet -> EmotionSet in

       
                    let fixedImages = emotionSet.images.map {
                        return $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0
                    }

                    let sortedImages = fixedImages.sorted { image1, image2 in
                        let name1 = image1.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
                        let name2 = image2.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
                        let index1 = targetOrder.firstIndex(of: name1) ?? Int.max
                        let index2 = targetOrder.firstIndex(of: name2) ?? Int.max
                        return index1 < index2
                    }

            

                    return EmotionSet(setName: emotionSet.setName, images: sortedImages)
                }

                self.classicMatchedSets = matchedSets
                self.classicCollectionView.reloadData()

            case .failure(let error):
                loadingView.isHidden = true
            }

            self.updateBuyButtonVisibility()
        }
    }



    private func extractSetNumber(from setName: String) -> Int {
        let components = setName.components(separatedBy: " ")
        if let lastComponent = components.last, let number = Int(lastComponent) {
            return number
        }
        return Int.max
    }



    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = AppColors.color5
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AppColors.color5
        ]
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
}
