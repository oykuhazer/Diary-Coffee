//
//  CustomTabBarController.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 20.10.2024.
//

import UIKit

class CustomTabBarController: UITabBarController {

    let circularView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the custom tab bar
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")

        // Tab Bar background color and other customizations
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            // Set the lighter background color for the tab bar
            appearance.backgroundColor = UIColor(red: 0.95, green: 0.92, blue: 0.88, alpha: 1.0) // Tab bar background color
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }

        tabBar.tintColor = UIColor(red: 0.95, green: 0.92, blue: 0.88, alpha: 1.0)
        tabBar.unselectedItemTintColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)

        // Add your view controllers
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

        let controllers = [calendarVC, analysisVC, storeVC, profileVC]
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }

        // Add the circular view inside the central dip
        addCircularView()
    }

    private func addCircularView() {
        let diameter: CGFloat = 70 // Diameter of the circle
        let centerX = tabBar.bounds.width / 2 - diameter / 2
        
        // Adjust the 'centerY' to move the circle higher
        let centerY = tabBar.bounds.minY - (diameter * 0.7) // Adjust to the preferred height

        // Setup circularView
        circularView.frame = CGRect(x: centerX, y: centerY, width: diameter, height: diameter)
        
        // Set the darker background color for the circular view
        circularView.backgroundColor = UIColor(red: 0.35, green: 0.25, blue: 0.2, alpha: 1.0) // Circular view background color
        
        circularView.layer.cornerRadius = diameter / 2
        circularView.layer.masksToBounds = false // Needed to allow the shadow to extend beyond the bounds

        // Add a subtle border to make the circle more prominent
        circularView.layer.borderWidth = 2
        circularView.layer.borderColor = UIColor(red: 0.95, green: 0.92, blue: 0.88, alpha: 1.0).cgColor // A lighter color for contrast

        // Apply shadow to the circular view to make it pop
        circularView.layer.shadowColor = UIColor.black.cgColor
        circularView.layer.shadowOpacity = 0.3
        circularView.layer.shadowOffset = CGSize(width: 2, height: 2)
        circularView.layer.shadowRadius = 5 // Softer, more pronounced shadow

        // Add a larger image to the circular view
        let imageView = UIImageView(image: UIImage(named: "d")) // 'd' should be in your assets
        imageView.contentMode = .scaleAspectFit
        
        // Make the image bigger by reducing the padding
        imageView.frame = CGRect(x: 5, y: 5, width: diameter - 10, height: diameter - 10) // Minimal padding for a larger image

        // Apply a subtle shadow to the image view
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        imageView.layer.shadowRadius = 3
        imageView.layer.masksToBounds = false

        // Add imageView to the circular view
        circularView.addSubview(imageView)

        // Add circularView to the tab bar
        tabBar.addSubview(circularView)
    }



}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


