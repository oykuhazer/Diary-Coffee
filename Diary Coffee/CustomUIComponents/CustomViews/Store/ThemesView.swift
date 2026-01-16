//
//  ThemesView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 29.11.2024.
//


import UIKit

class ThemesView: UIView {

    enum ThemeType {
            case special
            case classic
        }

    var currentSelectedTheme: ThemeType = .special
    weak var delegate: ThemesViewDelegate?
    
    var themeStackView: UIStackView = {
          let stackView = UIStackView()
          stackView.axis = .horizontal
          stackView.spacing = 20
          stackView.alignment = .center
          stackView.distribution = .fillEqually
          return stackView
      }()
      
    var specialThemeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("special_theme", comment: ""), for: .normal)
        button.backgroundColor = AppColors.color13
        button.setTitleColor(AppColors.color14, for: .normal)
        button.layer.cornerRadius = 10
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()

    var classicThemeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("classic_theme", comment: ""), for: .normal)
        button.backgroundColor = AppColors.color13
        button.setTitleColor(AppColors.color14, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()

    
    var emotionCollectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .vertical
           layout.minimumLineSpacing = 90
           layout.minimumInteritemSpacing = 10
           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
           collectionView.backgroundColor = AppColors.color1
           collectionView.register(EmotionSetCell.self, forCellWithReuseIdentifier: EmotionSetCell.identifier)
           return collectionView
       }()
       
    var primeCollectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .vertical
           layout.minimumLineSpacing = 90
           layout.minimumInteritemSpacing = 10
           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
  
           collectionView.backgroundColor = AppColors.color1
           collectionView.register(PrimeEmotionSetCell.self, forCellWithReuseIdentifier: PrimeEmotionSetCell.identifier)
           return collectionView
       }()
       
       var emotionSets: [EmotionSet] = []
       var primeEmotionSets: [PrimeEmotionSet] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
           addSubview(themeStackView)
           addSubview(emotionCollectionView)
           addSubview(primeCollectionView)

           themeStackView.translatesAutoresizingMaskIntoConstraints = false
           emotionCollectionView.translatesAutoresizingMaskIntoConstraints = false
           primeCollectionView.translatesAutoresizingMaskIntoConstraints = false

           themeStackView.addArrangedSubview(specialThemeButton)
           themeStackView.addArrangedSubview(classicThemeButton)

           NSLayoutConstraint.activate([
               themeStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
               themeStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
               themeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
               themeStackView.heightAnchor.constraint(equalToConstant: 50),
               
               emotionCollectionView.topAnchor.constraint(equalTo: themeStackView.bottomAnchor, constant: 50),
               emotionCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
               emotionCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
               emotionCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
               
               primeCollectionView.topAnchor.constraint(equalTo: themeStackView.bottomAnchor, constant: 40),
               primeCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
               primeCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
               primeCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
           ])
           
           emotionCollectionView.dataSource = self
           emotionCollectionView.delegate = self
           
           primeCollectionView.dataSource = self
           primeCollectionView.delegate = self

           specialThemeButton.addTarget(self, action: #selector(specialThemeTapped), for: .touchUpInside)
           classicThemeButton.addTarget(self, action: #selector(classicThemeTapped), for: .touchUpInside)

        specialThemeTapped()
       }
    
    @objc func specialThemeTapped() {
        currentSelectedTheme = .special
        updateButtonAppearance(selectedButton: specialThemeButton, deselectedButton: classicThemeButton)
        emotionCollectionView.isHidden = true
        primeCollectionView.isHidden = false
        
        delegate?.fetchEmotionSetIfClassicThemeSelected()
    }

    @objc func classicThemeTapped() {
        currentSelectedTheme = .classic
        updateButtonAppearance(selectedButton: classicThemeButton, deselectedButton: specialThemeButton)
        emotionCollectionView.isHidden = false
        primeCollectionView.isHidden = true
        
        delegate?.fetchEmotionSetIfClassicThemeSelected()
    }

    private func updateButtonAppearance(selectedButton: UIButton, deselectedButton: UIButton) {
        selectedButton.backgroundColor = AppColors.color15
           selectedButton.setTitleColor(AppColors.color5, for: .normal)
           deselectedButton.backgroundColor = AppColors.color13
           deselectedButton.setTitleColor(AppColors.color14, for: .normal)
       }

    func updateEmotionSets(_ sets: Any) {
          if let primeSets = sets as? [PrimeEmotionSet], currentSelectedTheme == .special {
              self.primeEmotionSets = primeSets
              
          } else if let normalSets = sets as? [EmotionSet], currentSelectedTheme == .classic {
              self.emotionSets = normalSets
          } else {
             
              return
          }
          emotionCollectionView.reloadData()
          primeCollectionView.reloadData()
      }
    
   func showBuyView(_ buyView: BuyView) {
       
        if let tabBarController = self.window?.rootViewController as? CustomTabBarController {
            tabBarController.tabBar.isHidden = true
            tabBarController.tabBar.isUserInteractionEnabled = false
            tabBarController.tabBar.items?.forEach { $0.isEnabled = false }

            tabBarController.circularView.isHidden = true
            tabBarController.circularView.isUserInteractionEnabled = false

            if let gestures = tabBarController.circularView.gestureRecognizers {
                gestures.forEach { tabBarController.circularView.removeGestureRecognizer($0) }
            }
        }

       
        buyView.onCloseTapped = { [weak self] in
            buyView.removeFromSuperview()

            if let tabBarController = self?.window?.rootViewController as? CustomTabBarController {
                tabBarController.tabBar.isHidden = false
                tabBarController.tabBar.isUserInteractionEnabled = true
                tabBarController.tabBar.items?.forEach { $0.isEnabled = true }

                tabBarController.circularView.isHidden = false
                tabBarController.circularView.isUserInteractionEnabled = true
            }
        }
        
        self.addSubview(buyView)
    }

}



