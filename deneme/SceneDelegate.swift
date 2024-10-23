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
        
        // CustomTabBarController'ı root view controller olarak atıyoruz
        let tabBarController = CustomTabBarController()
        
        // Pencerenin root view controller'ını ayarlayıp gösteriyoruz
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        // Window referansını saklıyoruz
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Scene'in sistem tarafından serbest bırakıldığı zaman çağrılır.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Scene aktif duruma geçtiğinde çağrılır.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Scene aktif durumdan inaktif duruma geçmeden önce çağrılır.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Scene arka plandan ön plana geçerken çağrılır.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Scene ön plandan arka plana geçtiğinde çağrılır.
    }

}
