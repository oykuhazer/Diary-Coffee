//
//  PremiumVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 21.11.2024.
//

import UIKit
import StoreKit

class PremiumVC: UIViewController {

    var onPremiumAccess: (() -> Void)?
    private var selectedButton: UIButton?
    private let freeTrialLabel = UILabel()
    private let cancelAnytimeLabel = UILabel()
    private let beginTrialButton = UIButton(type: .system)
    private let trialInfoLabel = UILabel()
    private let productIDs = ["com.dailycoffee_annual", "com.dailycoffee_monthly"]
    private var products: [SKProduct] = []
    private lazy var recordActionView: RequiredActionView = {
           let actionView = RequiredActionView(frame: self.view.bounds)
           actionView.translatesAutoresizingMaskIntoConstraints = false
           return actionView
       }()
    
    private var isUpdating: Bool = false
    private var indicatorView: IndicatorView!
    private var subscriptionInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        indicatorView = IndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.indicatorColor = AppColors.color5
        view.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -80)
        ])
        
      
        indicatorView.show()
        
        setupUI()
        
        
    }


    private func setupUI() {
     
        view.backgroundColor = AppColors.color12

        let premiumLabel = UILabel()
        premiumLabel.text =  NSLocalizedString("premium_pass", comment: "")
        premiumLabel.textColor = AppColors.color5
        premiumLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        premiumLabel.textAlignment = .center
        premiumLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(premiumLabel)

        
        let xmarkButton = UIButton(type: .system)
        xmarkButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        xmarkButton.tintColor = AppColors.color5
        xmarkButton.translatesAutoresizingMaskIntoConstraints = false
        xmarkButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        xmarkButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        view.addSubview(xmarkButton)

        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

       
        let crownImageView = UIImageView()
        crownImageView.image = UIImage(named: "crown")
        crownImageView.contentMode = .scaleAspectFit
        crownImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(crownImageView)

      
        freeTrialLabel.text = NSLocalizedString("free_3_days", comment: "")
        freeTrialLabel.textColor = AppColors.color5
        freeTrialLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        freeTrialLabel.textAlignment = .center
        freeTrialLabel.numberOfLines = 0
        freeTrialLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(freeTrialLabel)
        
        cancelAnytimeLabel.text = NSLocalizedString("cancel_anytime", comment: "")
        cancelAnytimeLabel.textColor = AppColors.color5
        cancelAnytimeLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cancelAnytimeLabel.textAlignment = .center
        cancelAnytimeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cancelAnytimeLabel)

    
        let optionsContainer = UIStackView()
        optionsContainer.axis = .vertical
        optionsContainer.spacing = 10
        optionsContainer.alignment = .fill
        optionsContainer.distribution = .fillEqually
        optionsContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(optionsContainer)

        
        StoreManager.shared.fetchProducts(productIDs: productIDs) { [weak self] products in
            guard let self = self else { return }
            self.products = products
            
            
            DispatchQueue.main.async {
              self.indicatorView.hide()
                self.updateSubscriptionInfoLabel()
                self.updateTrialInfoLabel()
                
                for product in products {
                    if product.productIdentifier == "com.dailycoffee_monthly" {
                        
                        let adjustedPrice = product.price.doubleValue + 30.0
                             
                             let currencySymbol = product.priceLocale.currencySymbol ?? ""
                             let adjustedPriceString = "\(currencySymbol)\(String(format: "%.2f", adjustedPrice))"
                        
                             let monthlyButton = self.createOptionButton(
                                 title: NSLocalizedString("monthly_pass", comment: ""),
                                 details: nil,
                                 price: product.priceString,
                                 subPrice: "\(adjustedPriceString)",
                                 isAnnualPass: false
                             )
                             optionsContainer.addArrangedSubview(monthlyButton)
                    } else if product.productIdentifier == "com.dailycoffee_annual" {
                        let currencySymbol = product.priceLocale.currencySymbol ?? ""
                        let perMonthPrice = String(format: "%.2f", product.price.doubleValue / 12)
                        let formattedPrice = "\(currencySymbol)\(perMonthPrice)"

                        let annualButton = self.createOptionButton(
                            title: NSLocalizedString("annual_pass", comment: ""),
                            details: NSLocalizedString("free_for_3_days", comment: ""),
                            price: product.priceString,
                            subPrice: String(
                                format: NSLocalizedString("per_month", comment: ""),
                                formattedPrice
                            ),
                            isAnnualPass: true
                        )

                        optionsContainer.addArrangedSubview(annualButton)
                        self.setOptionSelected(annualButton)
                    }

                }
            }
        }

        
        let collectionView = PremiumOptionsCollectionView()
        contentView.addSubview(collectionView)

        let giftedBeansLabel = UILabel()
             giftedBeansLabel.text = NSLocalizedString("coffee_beans_gifted", comment: "")
             giftedBeansLabel.textColor = AppColors.color16
             giftedBeansLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
             giftedBeansLabel.textAlignment = .center
        giftedBeansLabel.numberOfLines = 0
             giftedBeansLabel.translatesAutoresizingMaskIntoConstraints = false
             contentView.addSubview(giftedBeansLabel)
         
        let termsPrivacyLabel = UILabel()
        let termsText = "\(NSLocalizedString("terms_of_service", comment: "")) \(NSLocalizedString("and", comment: "")) \(NSLocalizedString("privacy_policy", comment: ""))"
        let attributedString = NSMutableAttributedString(string: termsText)

       
        let termsRange = (termsText as NSString).range(of: NSLocalizedString("terms_of_service", comment: ""))
        attributedString.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: AppColors.color16,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ], range: termsRange)

       
        let privacyRange = (termsText as NSString).range(of: NSLocalizedString("privacy_policy", comment: ""))
        attributedString.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: AppColors.color16,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ], range: privacyRange)

        
        let andRange = (termsText as NSString).range(of: NSLocalizedString("and", comment: ""))
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: AppColors.color16
        ], range: andRange)

       
        termsPrivacyLabel.attributedText = attributedString
        termsPrivacyLabel.textAlignment = .center
        termsPrivacyLabel.numberOfLines = 0
        termsPrivacyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(termsPrivacyLabel)
        
        subscriptionInfoLabel = UILabel()
        subscriptionInfoLabel.textColor = AppColors.color16
        subscriptionInfoLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        subscriptionInfoLabel.textAlignment = .center
        subscriptionInfoLabel.numberOfLines = 0
        subscriptionInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subscriptionInfoLabel)

        updateSubscriptionInfoLabel()
        
      
        let fixedFooterView = UIView()
         fixedFooterView.backgroundColor = AppColors.color12
         fixedFooterView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(fixedFooterView)
  
        beginTrialButton.setTitle(NSLocalizedString("begin_free_trial", comment: ""), for: .normal)

         beginTrialButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
         beginTrialButton.setTitleColor(AppColors.color3, for: .normal)
         beginTrialButton.backgroundColor = AppColors.color5
         beginTrialButton.layer.cornerRadius = 12
         beginTrialButton.translatesAutoresizingMaskIntoConstraints = false
        beginTrialButton.addTarget(self, action: #selector(beginTrialTapped), for: .touchUpInside)
         fixedFooterView.addSubview(beginTrialButton)

        trialInfoLabel.textColor = AppColors.color16
        trialInfoLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        trialInfoLabel.textAlignment = .center
        trialInfoLabel.numberOfLines = 0
        trialInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        fixedFooterView.addSubview(trialInfoLabel)

        updateTrialInfoLabel()

        
        let chatBubble = createChatBubbleWithGift()
        view.addSubview(chatBubble)
        
        NSLayoutConstraint.activate([
          
            premiumLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            premiumLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

          
            xmarkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            xmarkButton.centerYAnchor.constraint(equalTo: premiumLabel.centerYAnchor),

          
            scrollView.topAnchor.constraint(equalTo: premiumLabel.bottomAnchor, constant: 10),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: fixedFooterView.topAnchor),

             
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            crownImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            crownImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            crownImageView.widthAnchor.constraint(equalToConstant: 70),
            crownImageView.heightAnchor.constraint(equalToConstant: 70),

           
            freeTrialLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            freeTrialLabel.topAnchor.constraint(equalTo: crownImageView.bottomAnchor, constant: 5),
            freeTrialLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            freeTrialLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            cancelAnytimeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cancelAnytimeLabel.topAnchor.constraint(equalTo: freeTrialLabel.bottomAnchor, constant: 4),

           
            optionsContainer.topAnchor.constraint(equalTo: cancelAnytimeLabel.bottomAnchor, constant: 30),
            optionsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            optionsContainer.heightAnchor.constraint(equalToConstant: 200),
            
            collectionView.topAnchor.constraint(equalTo: optionsContainer.bottomAnchor, constant: 30),
                     collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                     collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                     collectionView.heightAnchor.constraint(equalToConstant: 830),

                     giftedBeansLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
                     giftedBeansLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                     giftedBeansLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                     
            termsPrivacyLabel.topAnchor.constraint(equalTo: giftedBeansLabel.bottomAnchor, constant: 30),
               termsPrivacyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
               termsPrivacyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subscriptionInfoLabel.topAnchor.constraint(equalTo: termsPrivacyLabel.bottomAnchor, constant: 20),
                subscriptionInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                subscriptionInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subscriptionInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
            
            fixedFooterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                fixedFooterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                fixedFooterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 20),
                fixedFooterView.heightAnchor.constraint(equalToConstant: 100),

                
             beginTrialButton.topAnchor.constraint(equalTo: fixedFooterView.topAnchor, constant: 10),
             beginTrialButton.leadingAnchor.constraint(equalTo: fixedFooterView.leadingAnchor, constant: 16),
             beginTrialButton.trailingAnchor.constraint(equalTo: fixedFooterView.trailingAnchor, constant: -16),
            beginTrialButton.heightAnchor.constraint(equalToConstant: 50),

                
             trialInfoLabel.topAnchor.constraint(equalTo: beginTrialButton.bottomAnchor, constant: 8),
             trialInfoLabel.leadingAnchor.constraint(equalTo: fixedFooterView.leadingAnchor, constant: 16),
            trialInfoLabel.trailingAnchor.constraint(equalTo: fixedFooterView.trailingAnchor, constant: -16),
            chatBubble.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
               chatBubble.topAnchor.constraint(equalTo: beginTrialButton.topAnchor, constant: -70),
               chatBubble.widthAnchor.constraint(equalToConstant: 80),
               chatBubble.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func updateSubscriptionInfoLabel() {
        guard let monthlyProduct = products.first(where: { $0.productIdentifier == "com.dailycoffee_monthly" }),
              let annualProduct = products.first(where: { $0.productIdentifier == "com.dailycoffee_annual" }) else {
            
          
            subscriptionInfoLabel.text = NSLocalizedString("subscription_unavailable", comment: "")
            return
        }

       
        let subscriptionInfoText = String(
            format: NSLocalizedString("apple_account_subscription", comment: ""),
            monthlyProduct.priceString,
            annualProduct.priceString
        )
        
        subscriptionInfoLabel.text = subscriptionInfoText
    }


    private func updateTrialInfoLabel() {
        guard let annualProduct = products.first(where: { $0.productIdentifier == "com.dailycoffee_annual" }) else {
          
            trialInfoLabel.text = NSLocalizedString("trial_info_unavailable", comment: "")
            return
        }

       
        let trialInfoText = String(
            format: NSLocalizedString("trial_info_annual", comment: ""),
            annualProduct.priceString
        )
        
        trialInfoLabel.text = trialInfoText
    }

    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    
    private func createChatBubbleWithGift() -> UIView {
        let chatBubble = UIView()
        chatBubble.backgroundColor = AppColors.color17
        chatBubble.layer.cornerRadius = 12
        chatBubble.layer.shadowColor = UIColor.black.cgColor
        chatBubble.layer.shadowOpacity = 0.2
        chatBubble.layer.shadowOffset = CGSize(width: 0, height: 2)
        chatBubble.layer.shadowRadius = 4
        chatBubble.translatesAutoresizingMaskIntoConstraints = false

        let giftImageView = UIImageView(image: UIImage(named: "gift"))
        giftImageView.contentMode = .scaleAspectFill
        giftImageView.translatesAutoresizingMaskIntoConstraints = false
        chatBubble.addSubview(giftImageView)

        NSLayoutConstraint.activate([
          
            giftImageView.centerXAnchor.constraint(equalTo: chatBubble.centerXAnchor),
            giftImageView.centerYAnchor.constraint(equalTo: chatBubble.centerYAnchor),
            giftImageView.widthAnchor.constraint(equalTo: chatBubble.widthAnchor, multiplier: 0.7),
            giftImageView.heightAnchor.constraint(equalTo: chatBubble.heightAnchor, multiplier: 0.7),
            
         
        ])

    
        return chatBubble
    }

    private func createOptionButton(title: String, details: String?, price: String, subPrice: String?, isAnnualPass: Bool = false) -> UIButton {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppColors.color18

        let selectionIndicator = UIView()
        selectionIndicator.layer.cornerRadius = 12
        selectionIndicator.layer.borderWidth = 1.5
        selectionIndicator.layer.borderColor = AppColors.color19.cgColor
        selectionIndicator.backgroundColor = .clear
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(selectionIndicator)

        let innerCircle = UIView()
        innerCircle.layer.cornerRadius = 6
        innerCircle.backgroundColor = AppColors.color20
        innerCircle.translatesAutoresizingMaskIntoConstraints = false
        selectionIndicator.addSubview(innerCircle)

        let infoStackView = UIStackView()
        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.spacing = 4
        infoStackView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = AppColors.color7
        titleLabel.tag = 100

        let detailsLabel = UILabel()
        detailsLabel.text = details ?? ""
        detailsLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        detailsLabel.textColor = AppColors.color16

        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(detailsLabel)

        let priceStackView = UIStackView()
        priceStackView.axis = .vertical
        priceStackView.alignment = .trailing
        priceStackView.spacing = 4
        priceStackView.translatesAutoresizingMaskIntoConstraints = false

        let priceLabel = UILabel()
        priceLabel.text = price
        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        priceLabel.textColor = AppColors.color21
        priceStackView.addArrangedSubview(priceLabel)

        if let subPrice = subPrice {
            let subPriceLabel = UILabel()
            
            let attributes: [NSAttributedString.Key: Any]
            if isAnnualPass {
                attributes = [
                    .foregroundColor: AppColors.color16,
                    .font: UIFont.systemFont(ofSize: 14, weight: .regular)
                ]
            } else {
                attributes = [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: AppColors.color16,
                    .font: UIFont.systemFont(ofSize: 14, weight: .regular)
                ]
            }

            let attributedText = NSAttributedString(string: subPrice, attributes: attributes)
            subPriceLabel.attributedText = attributedText
            priceStackView.addArrangedSubview(subPriceLabel)
        }
        button.addSubview(infoStackView)
        button.addSubview(priceStackView)

        NSLayoutConstraint.activate([
            selectionIndicator.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            selectionIndicator.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            selectionIndicator.widthAnchor.constraint(equalToConstant: 24),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 24),

            innerCircle.centerXAnchor.constraint(equalTo: selectionIndicator.centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: selectionIndicator.centerYAnchor),
            innerCircle.widthAnchor.constraint(equalToConstant: 12),
            innerCircle.heightAnchor.constraint(equalToConstant: 12),

            infoStackView.leadingAnchor.constraint(equalTo: selectionIndicator.trailingAnchor, constant: 16),
            infoStackView.centerYAnchor.constraint(equalTo: button.centerYAnchor),

            priceStackView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
            priceStackView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])

        button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
        button.tag = selectionIndicator.hashValue

        return button
    }


    @objc private func optionButtonTapped(_ sender: UIButton) {
        setOptionSelected(sender)
        
     
        if let titleLabel = sender.viewWithTag(100) as? UILabel {
            if titleLabel.text == NSLocalizedString("monthly_pass", comment: "") {
               
                updateTextForMonthlyPass()
                if let product = products.first(where: { $0.productIdentifier == "com.dailycoffee_monthly" }) {
                    startPurchase(for: product)
                }
            } else if titleLabel.text == NSLocalizedString("annual_pass", comment: "") {
             
                updateTextForAnnualPass()
                if let product = products.first(where: { $0.productIdentifier == "com.dailycoffee_annual" }) {
                    startPurchase(for: product)
                }
            }
        }
    }

    
    private func startPurchase(for product: SKProduct) {
        StoreManager.shared.purchase(product: product) { success, error in
            DispatchQueue.main.async {
                if success {
                 
                } else {
                    
                }
            }
        }
    }

    private func updateTextForMonthlyPass() {
        guard let monthlyProduct = products.first(where: { $0.productIdentifier == "com.dailycoffee_monthly" }) else {
            return
        }
        
        freeTrialLabel.text = NSLocalizedString("subscribe_premium_pass", comment: "")
        beginTrialButton.setTitle(NSLocalizedString("become_premium_user", comment: ""), for: .normal)
        cancelAnytimeLabel.isHidden = true
        trialInfoLabel.text = String(
            format: NSLocalizedString("monthly_trial_info", comment: ""),
            monthlyProduct.priceString
        )
    }

    private func updateTextForAnnualPass() {
        guard let annualProduct = products.first(where: { $0.productIdentifier == "com.dailycoffee_annual" }) else {
            return
        }
        
      
        freeTrialLabel.text = NSLocalizedString("completely_free_3_days", comment: "")
        beginTrialButton.setTitle(NSLocalizedString("begin_free_trial", comment: ""), for: .normal)
        cancelAnytimeLabel.isHidden = false
        trialInfoLabel.text = String(
            format: NSLocalizedString("annual_trial_info", comment: ""),
            annualProduct.priceString
        )
    }



    private func setOptionSelected(_ button: UIButton) {
        if let previousSelection = selectedButton,
           let previousIndicator = previousSelection.viewWithTag(previousSelection.tag) {
            UIView.animate(withDuration: 0.2) {
                previousIndicator.layer.borderWidth = 0.0
                previousIndicator.subviews.first?.backgroundColor = .clear
            }
            previousSelection.viewWithTag(100)?.tintColor = AppColors.color17
        }

        if let indicator = button.viewWithTag(button.tag) {
            UIView.animate(withDuration: 0.2) {
                indicator.layer.borderColor = AppColors.color5.cgColor
                indicator.layer.borderWidth = 4.0
                indicator.subviews.first?.backgroundColor = AppColors.color5
            }
        }
        selectedButton = button
    }

    @objc private func beginTrialTapped() {
        guard let selectedButton = selectedButton else {
          
            return
        }

        let productID: String
        let premiumType: String
        var premiumDaysLeft: Int
       
        if let titleLabel = selectedButton.viewWithTag(100) as? UILabel, titleLabel.text == NSLocalizedString("monthly_pass", comment: "") {
            productID = "com.dailycoffee_monthly"
            premiumType = NSLocalizedString("monthly_pass", comment: "")
            premiumDaysLeft = 30
        } else {
            productID = "com.dailycoffee_annual"
            premiumType = NSLocalizedString("annual_pass", comment: "")
            premiumDaysLeft = 365
        }

        if let product = products.first(where: { $0.productIdentifier == productID }) {
            StoreManager.shared.purchase(product: product) { [weak self] success, error in
                DispatchQueue.main.async {
                    guard let self = self else { return }

                    if success {
                      
                        self.updateUserProfile(premiumType: premiumType, premiumDaysLeft: premiumDaysLeft)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                       
                        self.recordActionView.configure(
                            icon: UIImage(named: "signal"),
                            message: NSLocalizedString("payment_failed", comment: "")
                        )

                        if self.recordActionView.superview == nil {
                            self.view.addSubview(self.recordActionView)
                            NSLayoutConstraint.activate([
                                self.recordActionView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                self.recordActionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                self.recordActionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                self.recordActionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                            ])
                        }

                
                        self.recordActionView.isHidden = false

                
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            UIView.animate(withDuration: 0.3, animations: {
                                self.recordActionView.alpha = 0.0
                            }) { _ in
                                self.recordActionView.isHidden = true
                                self.recordActionView.alpha = 1.0
                            }
                        }
                    }
                }
            }
        }
    }



    private func updateUserProfile(premiumType: String, premiumDaysLeft: Int) {
      
        guard !isUpdating else {
           
            return
        }
        isUpdating = true

     
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: currentDate)

       
        UserProfile.shared.premium = true
        UserProfile.shared.premiumType = premiumType
        UserProfile.shared.premiumStartDate = currentDate
        UserProfile.shared.premiumDaysLeft = premiumDaysLeft
        UserProfile.shared.quantityBeans! += 180
        let newEmotions = [
            Emotion(category: "ClassicSet1", description: NSLocalizedString("for_lovers_of_classic_cups", comment: "")),
            Emotion(category: "ClassicSet2", description: NSLocalizedString("for_lovers_of_classic_cups", comment: "")),
            Emotion(category: "ClassicSet3", description: NSLocalizedString("for_lovers_of_classic_cups", comment: "")),
            Emotion(category: "ClassicSet4", description: NSLocalizedString("for_lovers_of_classic_cups", comment: "")),
            Emotion(category: "ClassicSet5", description: NSLocalizedString("for_lovers_of_classic_cups",comment: ""))
        ]
        UserProfile.shared.purchasedEmotions.append(contentsOf: newEmotions)

      
        SaveUserProfileRequest.shared.saveUserProfile(in: self.view) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUpdating = false
                switch result {
                case .success:
                    self?.onPremiumAccess?() 
                    self?.dismiss(animated: true, completion: nil)
                  
                case .failure(let error): break
                    
                }
            }
        }
    }
}


