//
//  StoreVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 20.10.2024.
//


extension Notification.Name {
    static let showRequiredActionView = Notification.Name("showRequiredActionView")
}


extension Notification.Name {
    static let coffeeLabelDidUpdate = Notification.Name("coffeeLabelDidUpdate")
}

import UIKit
import StoreKit

protocol ThemesViewDelegate: AnyObject {
    func fetchEmotionSetIfClassicThemeSelected()
}


class StoreVC: UIViewController,  ThemesViewDelegate {
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            NSLocalizedString("themes", comment: ""),
            NSLocalizedString("stickers", comment: ""),
            NSLocalizedString("beans", comment: "")
        ])

        control.selectedSegmentIndex = 0
        control.backgroundColor = AppColors.color15
        control.selectedSegmentTintColor = AppColors.color5
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        control.setTitleTextAttributes([.foregroundColor: AppColors.color3], for: .selected)
        return control
    }()

    private let beansView: BeansView = {
        let view = BeansView()
        view.isHidden = true
        return view
    }()

    private let themesView = ThemesView()
    private let stickerView = StoreStickerView()
  
    private var products: [SKProduct] = []
    
    private let coffeeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = AppColors.color15
        label.textColor = AppColors.color5
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.textAlignment = .center

        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "coffeebeans")?.withRenderingMode(.alwaysOriginal)
        attachment.bounds = CGRect(x: 5, y: -3, width: 18, height: 18)
        let attachmentString = NSAttributedString(attachment: attachment)

        let quantity = UserProfile.shared.quantityBeans ?? 0
        let textString = NSAttributedString(
            string: "   \(quantity)",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 16)]
        )


        let combinedString = NSMutableAttributedString()
        combinedString.append(attachmentString)
        combinedString.append(textString)
        label.attributedText = combinedString

        return label
    }()

    private let categories: [String] = [
        "Alone", "Autumn", "Book", "Camping", "Catlover", "Christmas", "Coffee", "Communication", "Creativity",
        "Dessert", "Diet", "Doglover", "Emotion", "Flirt", "Hobbies", "Holiday", "Love", "Meditation",
        "Mentalhealth", "Morning", "Night", "Planner", "Podcast", "Relationship", "School", "Selfcare",
        "Shopping", "Socialmedia", "Spring", "Time", "Traveling", "Valentine", "Weather", "Winter", "Working",
        "Workout", "Yoga"
    ]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        themesView.specialThemeTapped()
        fetchEmotionSetIfClassicThemeSelected()
        fetchProducts()
        NotificationCenter.default.addObserver(
               self,
               selector: #selector(handleCoffeeLabelUpdate),
               name: .coffeeLabelDidUpdate,
               object: nil
           )
        beansView.storeVC = self
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleShowRequiredActionView(_:)),
                name: .showRequiredActionView,
                object: nil
            )
        
        updateCoffeeLabel()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCoffeeLabel()
    }


    @objc private func handleCoffeeLabelUpdate() {
        updateCoffeeLabel()
    }
    
    
    @objc private func handleShowRequiredActionView(_ notification: Notification) {
        let title = notification.userInfo?["title"] as? String ?? "Unknown Item"
        let message = notification.userInfo?["message"] as? String ?? "Action could not be completed."
        let iconName = notification.userInfo?["iconName"] as? String ?? "signal"
        showRequiredActionView(title: title, message: message, iconName: iconName)
    }



    
    private func fetchProducts() {
        let productIDs = ["com.dailycoffee.app.100beans", "com.dailycoffee.app.300beans", "com.dailycoffee.app.700beans", "com.dailycoffee.app.1500beans"]
        StoreManager.shared.fetchProducts(productIDs: productIDs) { [weak self] products in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.beansView.updateProducts(products)
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = NSLocalizedString("store", comment: "")
        navigationController?.navigationBar.barTintColor = AppColors.color3
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppColors.color5]
        view.backgroundColor = AppColors.color1
        
        let coffeeLabelItem = UIBarButtonItem(customView: coffeeLabel)
        navigationItem.rightBarButtonItem = coffeeLabelItem
        coffeeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coffeeLabel.widthAnchor.constraint(equalToConstant: 80),
            coffeeLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(coffeeLabelTapped))
            coffeeLabel.isUserInteractionEnabled = true
            coffeeLabel.addGestureRecognizer(tapGesture)
    }

    @objc private func coffeeLabelTapped() {
       
        segmentedControl.selectedSegmentIndex = 2
        segmentChanged()
    }
    
    private func setupUI() {
        view.addSubview(segmentedControl)
        view.addSubview(themesView)
        view.addSubview(stickerView)
        view.addSubview(beansView)
        themesView.delegate = self
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        themesView.translatesAutoresizingMaskIntoConstraints = false
        stickerView.translatesAutoresizingMaskIntoConstraints = false
        beansView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            themesView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            themesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            themesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            themesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stickerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            stickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            beansView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            beansView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            beansView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            beansView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
      
        themesView.isHidden = false
        stickerView.isHidden = true
        beansView.isHidden = true
    }

     func fetchEmotionSetIfClassicThemeSelected() {
       
        if themesView.currentSelectedTheme == .classic {
            fetchEmotionSet()
        } else if themesView.currentSelectedTheme == .special {
            fetchPrimeEmotionSet()
        }
    }



    @objc private func segmentChanged() {
        
        let selectedSegment = segmentedControl.selectedSegmentIndex

        stickerView.isHidden = (selectedSegment != 1)
        beansView.isHidden = (selectedSegment != 2)
        themesView.isHidden = (selectedSegment != 0)

        switch selectedSegment {
        case 0:
            fetchEmotionSetIfClassicThemeSelected()
        case 1:
            fetchAllStickers()
        case 2: break
           
        default:
            break
        }
    }

    private func fetchAllStickers() {
        
        let loadingView = LoadingView(frame: view.bounds)
        view.addSubview(loadingView)
        
        stickerView.categories = categories
        
        categories.forEach { category in
            StickerRequest.shared.uploadSticker(category: category) { [weak self] result in
                switch result {
                case .success(let response):
                    
                    loadingView.isHidden = true
                    
                    DispatchQueue.main.async {
                        self?.stickerView.stickers[category] = response.images
                    }
                case .failure(let error):
                    loadingView.isHidden = true
                    
                }
            }
        }
    }
    
    func fetchEmotionSet() {
        let loadingView = LoadingView(frame: view.bounds)
        view.addSubview(loadingView)

        EmotionSetRequest.shared.uploadEmotionSet(emotionSet: "") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                loadingView.isHidden = true

                guard response.resultCode == 200 else {
                    print("❌ API hatası: resultCode \(response.resultCode)")
                    return
                }

                let targetImageOrder = ["smile", "kissing", "wow", "sleep", "sad", "angry"]

                let sortedEmotionSets = (response.emotionSets ?? []).sorted { set1, set2 in
                    let number1 = self.extractSetNumber(from: set1.setName)
                    let number2 = self.extractSetNumber(from: set2.setName)
                    return number1 < number2
                }.map { emotionSet in
                    let fixedImages = emotionSet.images.map { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0 }

                    let sortedImages = fixedImages.sorted { image1, image2 in
                        let name1 = image1.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
                        let name2 = image2.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
                        let index1 = targetImageOrder.firstIndex(of: name1) ?? Int.max
                        let index2 = targetImageOrder.firstIndex(of: name2) ?? Int.max
                        return index1 < index2
                    }

                  

                    return EmotionSet(setName: emotionSet.setName, images: sortedImages)
                }


                DispatchQueue.main.async {
                    self.themesView.updateEmotionSets(sortedEmotionSets)
                }

            case .failure(let error):
                print("❌ API isteği başarısız oldu: \(error.localizedDescription)")
            }
        }
    }

 
    private func extractSetNumber(from setName: String) -> Int {
        let components = setName.components(separatedBy: " ")
        if let lastComponent = components.last, let number = Int(lastComponent) {
            return number
        }
        return Int.max
    }

    func updateCoffeeLabel() {
        let quantity = UserProfile.shared.quantityBeans ?? 0

        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "coffeebeans")?.withRenderingMode(.alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: -3, width: 18, height: 18)
        let attachmentString = NSAttributedString(attachment: attachment)

        let textString = NSAttributedString(
            string: "   \(quantity)",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 16)]
        )

        let combinedString = NSMutableAttributedString()
        combinedString.append(attachmentString)
        combinedString.append(textString)

        DispatchQueue.main.async {
            self.coffeeLabel.attributedText = combinedString

            let imageWidth: CGFloat = attachment.bounds.width
            let imagePadding: CGFloat = 5
            let textPadding: CGFloat = 10
            let rightPadding: CGFloat = 10
            let textWidth = textString.boundingRect(
                with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.coffeeLabel.bounds.height),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                context: nil
            ).width
            let totalWidth = imagePadding + imageWidth + textPadding + textWidth + rightPadding

            if let existingConstraint = self.coffeeLabel.constraints.first(where: { $0.firstAttribute == .width }) {
                self.coffeeLabel.removeConstraint(existingConstraint)
            }

            self.coffeeLabel.widthAnchor.constraint(equalToConstant: totalWidth).isActive = true
        }
    }

    func fetchPrimeEmotionSet() {
        let loadingView = LoadingView(frame: view.bounds)
        view.addSubview(loadingView)

        PrimeEmotionSetRequest.shared.uploadPrimeEmotionSet(primeEmotionSet: "", in: view) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                loadingView.isHidden = true

                guard response.resultCode == 200 else {
                    print("Error: \(response.resultMessage)")
                    return
                }

                let targetOrder = ["smile", "kissing", "wow", "sleep", "sad", "angry"]

             
                let sortedPrimeEmotionSets = response.primeEmotionSets?.compactMap { primeEmotionSet in
                    let sortedImages = primeEmotionSet.images.sorted { image1, image2 in
                        let name1 = image1.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
                        let name2 = image2.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
                        let index1 = targetOrder.firstIndex(of: name1) ?? Int.max
                        let index2 = targetOrder.firstIndex(of: name2) ?? Int.max
                        return index1 < index2
                    }
                    return PrimeEmotionSet(setName: primeEmotionSet.setName, images: sortedImages)
                } ?? []

              
                DispatchQueue.main.async {
                    self.themesView.updateEmotionSets(sortedPrimeEmotionSets)
                }

            case .failure(let error):
                loadingView.isHidden = true
               
            }
        }
    }

    
    func showRequiredActionView(success: Bool) {
        let recordActionView = RequiredActionView(frame: self.view.bounds)
        
        if success {
            recordActionView.configure(
                icon: UIImage(named: "success"),
                message: NSLocalizedString("payment_success", comment: "")
            )
        } else {
            recordActionView.configure(
                icon: UIImage(named: "signal"),
                message: NSLocalizedString("payment_failed", comment: "")
            )
        }
        
        self.view.addSubview(recordActionView)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            recordActionView.removeFromSuperview()
        }
    }

    func showRequiredActionView(title: String, message: String, iconName: String) {
        let recordActionView = RequiredActionView(frame: self.view.bounds)
        recordActionView.configure(
            icon: UIImage(named: iconName),
            message: "\(title) \(message)"
        )
        self.view.addSubview(recordActionView)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            recordActionView.removeFromSuperview()
        }
    }
 
    
    func showPremiumAccessView() {
            let premiumAccessView = PremiumAccessView(frame: view.bounds)
            view.addSubview(premiumAccessView)
            
            premiumAccessView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                premiumAccessView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                premiumAccessView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                premiumAccessView.topAnchor.constraint(equalTo: view.topAnchor),
                premiumAccessView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }

}









