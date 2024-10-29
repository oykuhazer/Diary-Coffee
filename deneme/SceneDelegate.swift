//
//  SceneDelegate.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 25.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // UIWindowScene'i kontrol ediyoruz
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Yeni bir pencere oluşturuyoruz
        let window = UIWindow(windowScene: windowScene)

        // CustomTabBarController'ı rootViewController olarak ayarlıyoruz
        let customTabBarController = CustomTabBarController()
        window.rootViewController = customTabBarController
        window.makeKeyAndVisible()

        // Window referansını saklıyoruz
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
