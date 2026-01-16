//
//  CustomTabBarController.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 20.10.2024.
//

extension UIImage {
 func resized(to size: CGSize) -> UIImage? {
     UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
     defer { UIGraphicsEndImageContext() }
     draw(in: CGRect(origin: .zero, size: size))
     return UIGraphicsGetImageFromCurrentImageContext()
 }
}


import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

 
 
 let circularView = UIView()
 var moodSelectionView: CalendarMoodSelectionView?
 var overlayView: UIView?
    var emojiImageURLs: [String] = []
    
 var isCircularViewHidden: Bool = false {
     didSet {
         circularView.isHidden = isCircularViewHidden
     }
 }
 
 
 override func viewDidLoad() {
     super.viewDidLoad()
     
     let customTabBar = CustomTabBar()
     setValue(customTabBar, forKey: "tabBar")

     if #available(iOS 15.0, *) {
         let appearance = UITabBarAppearance()
         appearance.configureWithOpaqueBackground()
         appearance.backgroundColor = AppColors.color29

         let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.clear]
         appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes
         appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributes

         appearance.inlineLayoutAppearance.normal.titleTextAttributes = attributes
         appearance.inlineLayoutAppearance.selected.titleTextAttributes = attributes
         appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = attributes
         appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = attributes

         tabBar.standardAppearance = appearance
         tabBar.scrollEdgeAppearance = appearance
     }


   

     
     tabBar.tintColor = AppColors.color29
     tabBar.unselectedItemTintColor = AppColors.color1

     let calendarVC = CalendarVC()
     let analysisVC = AnalysisVC()
     let storeVC = StoreVC()
     let profileVC = ProfileVC()

     calendarVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "calendar")?.resized(to: CGSize(width: 45, height: 45)), tag: 0)
     analysisVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "statistical")?.resized(to: CGSize(width: 40, height: 40)), tag: 1)
     storeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "store")?.resized(to: CGSize(width: 40, height: 40)), tag: 2)
     profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "user")?.resized(to: CGSize(width: 40, height: 40)), tag: 3)

     calendarVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
     analysisVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: -70, bottom: -10, right: 0)
     storeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: -70)
     profileVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)

     let controllers = [UINavigationController(rootViewController: calendarVC),
                        UINavigationController(rootViewController: analysisVC),
                        UINavigationController(rootViewController: storeVC),
                        UINavigationController(rootViewController: profileVC)]
     self.viewControllers = controllers

   // addCircularView()
     fetchProfileInformation()
     self.delegate = self
 }
 
 func fetchProfileInformation() {
     let userUUID = UserProfile.shared.uuid

     GetUserProfileInformationRequest.shared.fetchUserProfile(uuid: userUUID) { result in
         switch result {
         case .success(let response):
             guard let userProfileInfo = response.userProfileInfo else {
                 
                 return
             }
             
             if let styleSelection = userProfileInfo.styleSelection {
                 if styleSelection.contains("ClassicSet") {
                  
                     self.uploadClassicEmotionSet(emotionSet: styleSelection)
                    
                 } else {
                    
                     self.uploadPrimeEmotionSet(emotionSet: styleSelection)
                 }
             } else {
               
             }
         case .failure(let error): break
            
         }
     }
 }

    private func uploadClassicEmotionSet(emotionSet: String) {
        EmotionSetRequest.shared.uploadEmotionSet(emotionSet: emotionSet) { result in
            switch result {
            case .success(let response):
                if let classicEmotionSet = response.emotionSet,
                   let smileImageURLString = classicEmotionSet.images.first(where: { $0.contains("smile") }),
                   let smileImageURL = URL(string: smileImageURLString) {

                    self.emojiImageURLs = classicEmotionSet.images
                    
                   
                    self.downloadImage(from: smileImageURL) { image in
                        DispatchQueue.main.async {
                            if let smileImage = image {
                                self.addCircularView(smileImage: smileImage, isClassicSet: true)
                            } else {
                                self.addCircularView(isClassicSet: true)
                            }
                        }
                    }
                } else {
                    self.addCircularView(isClassicSet: true)
                }
            case .failure(let error):
                self.addCircularView(isClassicSet: true)
            }
        }
    }



    private func uploadPrimeEmotionSet(emotionSet: String) {
        PrimeEmotionSetRequest.shared.uploadPrimeEmotionSet(primeEmotionSet: emotionSet, in: view) { result in
            switch result {
            case .success(let response):
                if let primeEmotionSet = response.primeEmotionSet,
                   let smileImageURLString = primeEmotionSet.images.first(where: { $0.contains("smile") }),
                   let smileImageURL = URL(string: smileImageURLString) {

                    self.emojiImageURLs = primeEmotionSet.images
                    
            
                    self.downloadImage(from: smileImageURL) { image in
                        DispatchQueue.main.async {
                            if let smileImage = image {
                                self.addCircularView(smileImage: smileImage, isClassicSet: false)
                            } else {
                                self.addCircularView(isClassicSet: false)
                            }
                        }
                    }
                } else {
                    self.addCircularView(isClassicSet: false)
                }
            case .failure(let error):
                self.addCircularView(isClassicSet: false)
            }
        }
    }
    
    private func addCircularView(smileImage: UIImage? = nil, isClassicSet: Bool = false) {
        let diameter: CGFloat = 70
        let centerX = view.bounds.width / 2 - diameter / 2
        let centerY = tabBar.frame.minY - (diameter * 0.8)

        circularView.frame = CGRect(x: centerX, y: centerY, width: diameter, height: diameter)
        circularView.backgroundColor = AppColors.color30
        circularView.layer.cornerRadius = diameter / 2
        circularView.layer.borderWidth = 2
        circularView.layer.borderColor = AppColors.color29.cgColor
        circularView.layer.shadowColor = UIColor.black.cgColor
        circularView.layer.shadowOpacity = 0.3
        circularView.layer.shadowOffset = CGSize(width: 2, height: 2)
        circularView.layer.shadowRadius = 5

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        if let smileImage = smileImage {
            imageView.image = smileImage
        } else {
            imageView.image = UIImage(named: "b")
        }

        circularView.addSubview(imageView)

     
        let sizeMultiplier: CGFloat = isClassicSet ? 0.6 : 1.0

     
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: circularView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circularView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: diameter * sizeMultiplier),
            imageView.heightAnchor.constraint(equalToConstant: diameter * sizeMultiplier)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(circularViewTapped))
        circularView.addGestureRecognizer(tapGesture)
        circularView.isUserInteractionEnabled = true

        view.addSubview(circularView)
        view.bringSubviewToFront(circularView)
    }


 private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
     URLSession.shared.dataTask(with: url) { data, _, error in
         if let data = data, error == nil, let image = UIImage(data: data) {
             completion(image)
         } else {
             
             completion(nil)
         }
     }.resume()
 }


    @objc func circularViewTapped() {
        if moodSelectionView == nil {
            guard let parentVCView = self.view else { return }

            overlayView = UIView(frame: parentVCView.bounds)
            overlayView?.translatesAutoresizingMaskIntoConstraints = false
            parentVCView.addSubview(overlayView!)

            NSLayoutConstraint.activate([
                overlayView!.topAnchor.constraint(equalTo: parentVCView.topAnchor),
                overlayView!.bottomAnchor.constraint(equalTo: parentVCView.bottomAnchor),
                overlayView!.leadingAnchor.constraint(equalTo: parentVCView.leadingAnchor),
                overlayView!.trailingAnchor.constraint(equalTo: parentVCView.trailingAnchor)
            ])

            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = overlayView!.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlayView?.addSubview(blurEffectView)

            let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissCalendarMoodSelectionView))
            overlayView?.addGestureRecognizer(dismissTapGesture)

            let isClassicSet = emojiImageURLs.contains { $0.contains("ClassicSet") }

            let selectionView = CalendarMoodSelectionView(
                frame: CGRect(x: 20, y: view.bounds.height / 3, width: view.bounds.width - 40, height: 140),
                emojiImageURLs: emojiImageURLs,
                isClassicSet: isClassicSet
            )
            selectionView.layer.cornerRadius = 15
            selectionView.layer.masksToBounds = true
            moodSelectionView = selectionView
            overlayView?.addSubview(selectionView)

            NSLayoutConstraint.activate([
                selectionView.centerXAnchor.constraint(equalTo: overlayView!.centerXAnchor),
                selectionView.centerYAnchor.constraint(equalTo: overlayView!.centerYAnchor),
                selectionView.widthAnchor.constraint(equalToConstant: 360),
                selectionView.heightAnchor.constraint(equalToConstant: 400)
            ])
        } else {
            dismissCalendarMoodSelectionView()
        }
    }


 @objc private func dismissCalendarMoodSelectionView() {
     removeOverlayAndMoodSelection()
 }
 
 func removeOverlayAndMoodSelection() {
     moodSelectionView?.removeFromSuperview()
     overlayView?.removeFromSuperview()
     moodSelectionView = nil
     overlayView = nil
 }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navController = viewController as? UINavigationController,
           let firstVC = navController.viewControllers.first,
           firstVC is ProfileVC {

          
            navController.popToRootViewController(animated: true)
        }
    }


}

