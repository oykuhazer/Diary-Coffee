//
//  StoreStickerView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 28.11.2024.
//

import UIKit

class StoreStickerView: UIView {
 
    var  scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = AppColors.color1
        return scrollView
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let imageCacheQueue = DispatchQueue(label: "com.app.imageCacheQueue", attributes: .concurrent)
    
    var categories: [String] = [] {
        didSet {
            setupCategorySections()
        }
    }
    
    var stickers: [String: [String]] = [:] {
        didSet {
            reloadStickerViews()
        }
    }
    
     var imageCache: [String: UIImage] = [:]
    var descriptions: [String: String] = [
        "Alone": NSLocalizedString("coffee_break_alone", comment: ""),
        "Autumn": NSLocalizedString("warm_up_with_coffee", comment: ""),
        "Book": NSLocalizedString("coffee_accompanying_you", comment: ""),
        "Camping": NSLocalizedString("campfire_and_coffee", comment: ""),
        "Catlover": NSLocalizedString("coffee_with_purring_companion", comment: ""),
        "Christmas": NSLocalizedString("christmas_with_ginger_scented_coffee", comment: ""),
        "Coffee": NSLocalizedString("coffee_leads", comment: ""),
        "Communication": NSLocalizedString("coffee_in_conversations", comment: ""),
        "Creativity": NSLocalizedString("sip_of_coffee_inspiration", comment: ""),
        "Dessert": NSLocalizedString("coffee_and_dessert_harmony", comment: ""),
        "Diet": NSLocalizedString("balanced_coffee_break", comment: ""),
        "Doglover": NSLocalizedString("walk_with_coffee", comment: ""),
        "Emotion": NSLocalizedString("deepen_feelings_with_coffee", comment: ""),
        "Flirt": NSLocalizedString("sweet_closeness_with_coffee", comment: ""),
        "Hobbies": NSLocalizedString("coffee_complements_hobbies", comment: ""),
        "Holiday": NSLocalizedString("peaceful_moments_with_coffee", comment: ""),
        "Love": NSLocalizedString("warm_and_deep_like_coffee", comment: ""),
        "Meditation": NSLocalizedString("serenity_with_coffee", comment: ""),
        "Mentalhealth": NSLocalizedString("little_break_with_coffee", comment: ""),
        "Morning": NSLocalizedString("first_light_and_coffee", comment: ""),
        "Night": NSLocalizedString("make_night_beautiful_with_coffee", comment: ""),
        "Planner": NSLocalizedString("coffee_planning_day", comment: ""),
        "Podcast": NSLocalizedString("coffee_with_podcast", comment: ""),
        "Relationship": NSLocalizedString("coffee_with_moments_together", comment: ""),
        "School": NSLocalizedString("coffee_between_classes", comment: ""),
        "Selfcare": NSLocalizedString("coffee_is_self_love", comment: ""),
        "Shopping": NSLocalizedString("recharge_with_coffee", comment: ""),
        "Socialmedia": NSLocalizedString("share_coffee_moments", comment: ""),
        "Spring": NSLocalizedString("spring_freshness_and_coffee", comment: ""),
        "Time": NSLocalizedString("time_for_a_cup_of_coffee", comment: ""),
        "Traveling": NSLocalizedString("coffee_while_exploring", comment: ""),
        "Valentine": NSLocalizedString("romantic_coffee_with_loved_one", comment: ""),
        "Weather": NSLocalizedString("weather_and_coffee", comment: ""),
        "Winter": NSLocalizedString("warm_touch_in_winter", comment: ""),
        "Working": NSLocalizedString("power_of_coffee_at_work", comment: ""),
        "Workout": NSLocalizedString("refresh_after_workout", comment: ""),
        "Yoga": NSLocalizedString("balance_mind_body_with_coffee", comment: "")
    ]

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupCategorySections() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        categories.forEach { category in
            let containerView = UIView()
            containerView.backgroundColor = AppColors.color1
            
            let titleLabel = UILabel()
            titleLabel.text = category
            titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            titleLabel.textColor = AppColors.color22
            
            let collectionView = createCollectionView()
            collectionView.tag = categories.firstIndex(of: category) ?? 0
            collectionView.dataSource = self
            collectionView.delegate = self

            let descriptionLabel = UILabel()
            if let descriptionText = descriptions[String(category)] {
                descriptionLabel.text = descriptionText
            }
 else {
  
            }
            
            descriptionLabel.textColor = AppColors.color22
            descriptionLabel.font = UIFont.systemFont(ofSize: 14)
            descriptionLabel.numberOfLines = 0
            
            let coffeeLabel = createCoffeeLabel(for: category)
            containerView.addSubview(titleLabel)
            containerView.addSubview(collectionView)
            containerView.addSubview(descriptionLabel)
            containerView.addSubview(coffeeLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            coffeeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                
                collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
                collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                collectionView.heightAnchor.constraint(equalToConstant: 300),
                
                coffeeLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
                coffeeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                coffeeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
                coffeeLabel.widthAnchor.constraint(equalToConstant: 80),
                coffeeLabel.heightAnchor.constraint(equalToConstant: 30),
                
                descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                descriptionLabel.trailingAnchor.constraint(equalTo: coffeeLabel.leadingAnchor, constant: -10), 
                descriptionLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15)
            ])

            
            stackView.addArrangedSubview(containerView)
        }
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = AppColors.color22
        collectionView.layer.cornerRadius = 8
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "StickerCell")
        return collectionView
    }

    
    private func createCoffeeLabel(for category: String) -> UILabel {
        let label = UILabel()
        label.backgroundColor = AppColors.color15
        label.textColor = AppColors.color5
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.textAlignment = .center
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "coffeebeans")?.withRenderingMode(.alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: -3, width: 18, height: 18)
        let attachmentString = NSAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: " 350", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        let combinedString = NSMutableAttributedString()
        combinedString.append(attachmentString)
        combinedString.append(textString)
        
        label.attributedText = combinedString
        return label
    }


    private func reloadStickerViews() {
        stackView.arrangedSubviews.forEach { view in
            if let collectionView = view.subviews.compactMap({ $0 as? UICollectionView }).first {
                collectionView.reloadData()
            }
        }
    }
    
    
    func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
     
        imageCacheQueue.async {
            if let cachedImage = self.imageCache[url] {
                DispatchQueue.main.async {
                    completion(cachedImage)
                }
                return
            }
            
            guard let imageURL = URL(string: url) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
                if let data = data, let image = UIImage(data: data) {
                 
                    self?.imageCacheQueue.async(flags: .barrier) {
                        self?.imageCache[url] = image
                    }
                    
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            task.resume()
        }
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





