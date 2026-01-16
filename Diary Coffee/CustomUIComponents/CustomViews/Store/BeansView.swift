//
//  BeansView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 28.11.2024.
//



import UIKit
import StoreKit

class BeansView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var storeVC: StoreVC?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let premiumLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("premium_pass", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = AppColors.color5
        return label
    }()
    
    private let crownImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 45, weight: .bold)
        if let crownImage = UIImage(systemName: "crown.fill", withConfiguration: config) {
            imageView.image = crownImage.withTintColor(AppColors.color3, renderingMode: .alwaysOriginal)
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let firstView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.color45
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let giftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gift")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let beansLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("beans_180", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    
    private let giftedLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("gifted_on_subscription", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    private let learnMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("learn_more", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(AppColors.color5, for: .normal)
        button.backgroundColor = AppColors.color20
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let beansTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("beans", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = AppColors.color5
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private var products: [SKProduct] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        backgroundColor = AppColors.color1
        
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(crownImageView)
        contentView.addSubview(premiumLabel)
        contentView.addSubview(firstView)
        firstView.addSubview(giftImageView)
        firstView.addSubview(beansLabel)
        firstView.addSubview(giftedLabel)
        firstView.addSubview(learnMoreButton)
        contentView.addSubview(beansTitleLabel)
        contentView.addSubview(collectionView)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(firstViewTapped))
        firstView.addGestureRecognizer(tapGesture)
        firstView.isUserInteractionEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        setupConstraints()
    }
    
    @objc private func firstViewTapped() {
        if let parentVC = self.parentViewController as? StoreVC {
            let premiumVC = PremiumVC()
            premiumVC.modalPresentationStyle = .pageSheet
            
            
            premiumVC.onPremiumAccess = {
                parentVC.showPremiumAccessView()
            }
            
            parentVC.present(premiumVC, animated: true, completion: nil)
        }
    }
    
    
    
    func updateProducts(_ products: [SKProduct]) {
        self.products = products
        collectionView.reloadData()
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        crownImageView.translatesAutoresizingMaskIntoConstraints = false
        premiumLabel.translatesAutoresizingMaskIntoConstraints = false
        firstView.translatesAutoresizingMaskIntoConstraints = false
        giftImageView.translatesAutoresizingMaskIntoConstraints = false
        beansLabel.translatesAutoresizingMaskIntoConstraints = false
        giftedLabel.translatesAutoresizingMaskIntoConstraints = false
        learnMoreButton.translatesAutoresizingMaskIntoConstraints = false
        beansTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            crownImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            crownImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            crownImageView.widthAnchor.constraint(equalToConstant: 30),
            crownImageView.heightAnchor.constraint(equalToConstant: 30),
            
            premiumLabel.centerYAnchor.constraint(equalTo: crownImageView.centerYAnchor),
            premiumLabel.leadingAnchor.constraint(equalTo: crownImageView.trailingAnchor, constant: 8),
            
            firstView.topAnchor.constraint(equalTo: premiumLabel.bottomAnchor, constant: 10),
            firstView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            firstView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            firstView.heightAnchor.constraint(equalToConstant: 120),
            
            giftImageView.leadingAnchor.constraint(equalTo: firstView.leadingAnchor, constant: 12),
            giftImageView.centerYAnchor.constraint(equalTo: firstView.centerYAnchor),
            giftImageView.widthAnchor.constraint(equalToConstant: 50),
            giftImageView.heightAnchor.constraint(equalToConstant: 50),
            
            beansLabel.leadingAnchor.constraint(equalTo: giftImageView.trailingAnchor, constant: 16),
            beansLabel.topAnchor.constraint(equalTo: firstView.centerYAnchor, constant: -20),
            
            giftedLabel.leadingAnchor.constraint(equalTo: beansLabel.leadingAnchor),
            giftedLabel.topAnchor.constraint(equalTo: beansLabel.bottomAnchor, constant: 4),
            
            learnMoreButton.trailingAnchor.constraint(equalTo: firstView.trailingAnchor, constant: -12),
            learnMoreButton.centerYAnchor.constraint(equalTo: firstView.centerYAnchor),
            learnMoreButton.widthAnchor.constraint(equalToConstant: 100),
            learnMoreButton.heightAnchor.constraint(equalToConstant: 40),
            
            beansTitleLabel.topAnchor.constraint(equalTo: firstView.bottomAnchor, constant: 30),
            beansTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            
            collectionView.topAnchor.constraint(equalTo: beansTitleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 550),
            
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150)
        ])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        cell.backgroundColor = AppColors.color3
        cell.layer.cornerRadius = 12
        
        
        let imageNames = ["coffeebeans", "cookie", "beanspack", "beans"]
        
        
        let desiredOrder = ["com.dailycoffee.app.100beans", "com.dailycoffee.app.300beans", "com.dailycoffee.app.700beans", "com.dailycoffee.app.1500beans"]
        let sortedProducts = products.sorted { product1, product2 in
            guard let index1 = desiredOrder.firstIndex(of: product1.productIdentifier),
                  let index2 = desiredOrder.firstIndex(of: product2.productIdentifier) else {
                return false
            }
            return index1 < index2
        }
        
        if indexPath.item < sortedProducts.count {
            let product = sortedProducts[indexPath.item]
            
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            if indexPath.item < imageNames.count {
                imageView.image = UIImage(named: imageNames[indexPath.item])
            }
            cell.contentView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 50),
                imageView.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            
            let titleLabel = UILabel()
            titleLabel.text = product.localizedTitle
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.textColor = .white
            cell.contentView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
                titleLabel.topAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: -20)
            ])
            
            let secondaryTextLabel = UILabel()
            secondaryTextLabel.font = UIFont.boldSystemFont(ofSize: 14)
            secondaryTextLabel.textColor = UIColor.lightGray
            cell.contentView.addSubview(secondaryTextLabel)
            secondaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                secondaryTextLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
                secondaryTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
            ])
            
            
            switch indexPath.item {
            case 1:
                secondaryTextLabel.text = NSLocalizedString("bonus_19_percent", comment: "")
            case 2:
                secondaryTextLabel.text = NSLocalizedString("bonus_39_percent", comment: "")
            case 3:
                secondaryTextLabel.text = NSLocalizedString("bonus_79_percent", comment: "")
            default:
                secondaryTextLabel.text = nil
            }
            
            
            let priceButton = UIButton(type: .system)
            let priceFormatter = NumberFormatter()
            priceFormatter.numberStyle = .currency
            priceFormatter.locale = product.priceLocale
            let priceString = priceFormatter.string(from: product.price) ?? "N/A"
            priceButton.setTitle(priceString, for: .normal)
            priceButton.setTitleColor(AppColors.color5, for: .normal)
            priceButton.backgroundColor = AppColors.color20
            priceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            priceButton.layer.cornerRadius = 8
            priceButton.layer.borderWidth = 1.5
            priceButton.layer.borderColor = AppColors.color11.cgColor
            cell.contentView.addSubview(priceButton)
            priceButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                priceButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                priceButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                priceButton.widthAnchor.constraint(equalToConstant: 100),
                priceButton.heightAnchor.constraint(equalToConstant: 40)
            ])
        } else {
            
            let titleLabel = UILabel()
            titleLabel.text = "Unavailable"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.textColor = .white
            cell.contentView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.width
        return CGSize(width: collectionWidth, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let desiredOrder = ["com.dailycoffee.app.100beans", "com.dailycoffee.app.300beans", "com.dailycoffee.app.700beans", "com.dailycoffee.app.1500beans"]
        let sortedProducts = products.sorted { product1, product2 in
            guard let index1 = desiredOrder.firstIndex(of: product1.productIdentifier),
                  let index2 = desiredOrder.firstIndex(of: product2.productIdentifier) else {
                return false
            }
            return index1 < index2
        }
        
        
        let product = sortedProducts[indexPath.item]
        StoreManager.shared.purchase(product: product) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    
                    let beansToAdd: Int
                    switch product.productIdentifier {
                    case "com.dailycoffee.app.100beans":
                        beansToAdd = 100
                    case "com.dailycoffee.app.300beans":
                        beansToAdd = 300
                    case "com.dailycoffee.app.700beans":
                        beansToAdd = 700
                    case "com.dailycoffee.app.1500beans":
                        beansToAdd = 1500
                    default:
                        beansToAdd = 0
                    }
                    
                    let originalBeans = UserProfile.shared.quantityBeans ?? 0
                    UserProfile.shared.quantityBeans = originalBeans + beansToAdd
                    
                    SaveUserProfileRequest.shared.saveUserProfile(in: self!) { result in
                        switch result {
                        case .success:
                            self?.storeVC?.showRequiredActionView(success: true)
                            NotificationCenter.default.post(name: .coffeeLabelDidUpdate, object: nil)
                        case .failure(_):
                            
                            UserProfile.shared.quantityBeans = originalBeans
                            NotificationCenter.default.post(name: .coffeeLabelDidUpdate, object: nil)
                            self?.storeVC?.showRequiredActionView(success: false)
                        }
                    }
                } else {
                    self?.storeVC?.showRequiredActionView(success: false)
                }
            }
        }
    }
}

