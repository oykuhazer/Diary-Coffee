//
//  StickerSelectorView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 2.11.2024.
//

import UIKit
import Alamofire

class StickerSelectorView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    private let categories = ["Alone", "Autumn", "Book", "Camping", "Catlover", "Christmas", "Coffee", "Communication", "Creativity", "Dessert", "Diet", "Doglover", "Emotion", "Flirt", "Hobbies", "Holiday", "Love", "Meditation", "Mentalhealth", "Morning", "Night", "Planner", "Podcast", "Relationship", "School", "Selfcare", "Shopping", "Socialmedia", "Spring", "Time", "Traveling", "Valentine", "Weather", "Winter", "Working", "Workout", "Yoga"]

    private let textColor =  AppColors.color2
    private let backgroundColorForButtons =  AppColors.color3
    private let separatorColor = AppColors.color44
    private let selectedColor = AppColors.color45

    private var selectedButton: UIButton?
    private var images: [String] = []
    private var currentCategoryIndex = 0
    private var collectionView: UICollectionView!
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    private var overlayView: UIView!
    let bottomSeparator = UIView()
    var onStickerSelected: ((UIImage) -> Void)?
    private var purchasedStickerCategories: [String] = []

    private var sortedCategories: [String] {
        return purchasedStickerCategories + categories.filter { !purchasedStickerCategories.contains($0) }
    }

    private var buyButton: UIButton!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupCollectionView()
        setupBuyButton()
        setupGestureRecognizers()
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupCollectionView()
        setupBuyButton()
        setupGestureRecognizers()
    }

    private func setupView() {
        self.backgroundColor = AppColors.color20
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true

        setupScrollView()
        createCategoryButtons()
        setupBottomSeparator()
        setupBuyButton()
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
        
        self.addSubview(buyButton)

        buyButton.layer.shadowColor = UIColor.black.cgColor
        buyButton.layer.shadowOpacity = 0.5
        buyButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        buyButton.layer.shadowRadius = 4

        NSLayoutConstraint.activate([
            buyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buyButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            buyButton.widthAnchor.constraint(equalToConstant: 140),
            buyButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        buyButton.isHidden = true
    }


    
    @objc private func buyButtonTapped() {
        
        if let parentViewController = self.parentViewController {
            parentViewController.dismiss(animated: true) {
             
                if let customTabBarController = UIApplication.shared.windows.first?.rootViewController as? CustomTabBarController {
                    customTabBarController.selectedIndex = 2
                }
            }
        }
    }


    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            scrollView.heightAnchor.constraint(equalToConstant: 50)
        ])

        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }

  

    private func setupBottomSeparator() {
        bottomSeparator.backgroundColor = separatorColor
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomSeparator)

        NSLayoutConstraint.activate([
            bottomSeparator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            bottomSeparator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            bottomSeparator.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 8),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    func setPurchasedStickers(_ stickers: [String]) {
        self.purchasedStickerCategories = stickers
        selectedButton = nil
        createCategoryButtons()
        updateCategory()
    }

    @objc private func categoryButtonTapped(_ sender: UIButton) {
        let category = sortedCategories[sender.tag]
        currentCategoryIndex = sender.tag

        selectedButton?.backgroundColor = backgroundColorForButtons
        selectedButton?.setTitleColor(textColor, for: .normal)

        if let button = sender as? UIButton {
            button.backgroundColor = selectedColor
            button.setTitleColor(.white, for: .normal)
            selectedButton = button
        }

        if !purchasedStickerCategories.contains(category) {
            collectionView.alpha = 0.5
            buyButton.isHidden = false
        } else {
            collectionView.alpha = 1.0
            buyButton.isHidden = true
        }
        
        StickerRequest.shared.uploadSticker(category: category) { result in
            switch result {
            case .success(let response):
                self.images = response.images
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error): break
                
            }
        }
    }


    private func setupOverlayView() {
        overlayView = UIView()
        overlayView.backgroundColor = AppColors.color46
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: bottomSeparator.bottomAnchor),
            overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        overlayView.isHidden = true
    }

    

    private func updateCategory() {
        selectedButton?.backgroundColor = backgroundColorForButtons
        selectedButton?.setTitleColor(textColor, for: .normal)

        if let button = stackView.arrangedSubviews[currentCategoryIndex] as? UIButton {
            button.backgroundColor = selectedColor
            button.setTitleColor(.white, for: .normal)
            selectedButton = button
        }

        let category = sortedCategories[currentCategoryIndex]
        StickerRequest.shared.uploadSticker(category: category) { result in
            switch result {
            case .success(let response):
                self.images = response.images
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error): break
               
            }
        }
    }

    private func setupGestureRecognizers() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        var newIndex = currentCategoryIndex

        if gesture.direction == .left {
            if currentCategoryIndex < sortedCategories.count - 1 {
                newIndex += 1
            }
        } else if gesture.direction == .right {
            if currentCategoryIndex > 0 {
                newIndex -= 1
            }
        }

        currentCategoryIndex = newIndex

        selectedButton?.backgroundColor = backgroundColorForButtons
        selectedButton?.setTitleColor(textColor, for: .normal)

        if let button = stackView.arrangedSubviews[currentCategoryIndex] as? UIButton {
            button.backgroundColor = selectedColor
            button.setTitleColor(.white, for: .normal)
            selectedButton = button
        }

        let category = sortedCategories[currentCategoryIndex]

        if !purchasedStickerCategories.contains(category) {
            collectionView.alpha = 0.5
            buyButton.isHidden = false
        } else {
            collectionView.alpha = 1.0
            buyButton.isHidden = true
        }

        StickerRequest.shared.uploadSticker(category: category) { result in
            switch result {
            case .success(let response):
                self.images = response.images
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error): break
                
            }
        }
    }


    private func createCategoryButtons() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        var isCategorySelected = false

        for (index, category) in sortedCategories.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.backgroundColor = backgroundColorForButtons
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.widthAnchor.constraint(equalToConstant: 100).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)

            if purchasedStickerCategories.contains(category) {
                if !isCategorySelected || category == "Alone" {
                    button.backgroundColor = selectedColor
                    button.setTitleColor(.white, for: .normal)
                    selectedButton = button
                    currentCategoryIndex = index
                    isCategorySelected = true
                }
            }
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 60) / 4, height: (UIScreen.main.bounds.width - 60) / 4)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: bottomSeparator.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])

        overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.isHidden = true
        collectionView.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let imageUrl = URL(string: images[indexPath.row])
        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.contentView.addSubview(imageView)

        if let url = imageUrl {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }.resume()
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageUrl = images[indexPath.row]
        
       
        if let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                 
                    self.onStickerSelected?(image)
                    self.removeFromSuperview() 
                }
            }.resume()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
         
           if !buyButton.isHidden {
               return false
           }
           return true
       }

}
