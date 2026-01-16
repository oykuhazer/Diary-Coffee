//
//  SceneDelegate.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 25.09.2024.
//

import UIKit
 import Alamofire

 class SceneDelegate: UIResponder, UIWindowSceneDelegate {

     var window: UIWindow?
     private var connectManager: ConnectManager?
     private var pinLockRequired: Bool {
         return UserProfile.shared.isPasscodeEnabled
     }

     func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
         guard let windowScene = (scene as? UIWindowScene) else { return }
         
         
         _ = Bundle.swizzleLocalization
         
         let window = UIWindow(windowScene: windowScene)
             self.window = window
             self.showLaunchScreen()

         connectManager = ConnectManager(mainWindow: window)
               connectManager?.startMonitoring()
         
       
         self.window?.makeKeyAndVisible()
        
     }

     func sceneDidDisconnect(_ scene: UIScene) {}
     func sceneDidBecomeActive(_ scene: UIScene) {}
     func sceneWillResignActive(_ scene: UIScene) {}
     func sceneWillEnterForeground(_ scene: UIScene) {
         if pinLockRequired {
             showPinCodeScreen()
         }
     }
     func sceneDidEnterBackground(_ scene: UIScene) {
         if pinLockRequired {
             showPinCodeScreen()
         }
     }

     private func showPinCodeScreen() {
         guard let rootViewController = window?.rootViewController else { return }
         if rootViewController.presentedViewController is PinCodeLoginVC {
             return
         }
         let pinCodeLoginVC = PinCodeLoginVC()
         pinCodeLoginVC.modalPresentationStyle = .fullScreen
         rootViewController.present(pinCodeLoginVC, animated: true, completion: nil)
     }
     private func showLaunchScreen() {
         let launchVC = LaunchVC()
         window?.rootViewController = launchVC
         window?.makeKeyAndVisible()
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
             self.loadMainScreen()
         }
     }
     
     
     
     func loadMainScreen() {
         let uuid = UserProfile.shared.uuid

        GetUserProfileInformationRequest.shared.fetchUserProfile(uuid: uuid)  { result in
                switch result {
                case .success(let response):
                    
                    print(uuid)
                    if response.resultCode == 200, let profileInfo = response.userProfileInfo {
                
                        UserProfile.shared.updateProfile(with: profileInfo)
        
                        let customTabBarController = CustomTabBarController()
                        customTabBarController.selectedIndex = 0
                        customTabBarController.modalPresentationStyle = .fullScreen
                        self.window?.rootViewController = customTabBarController

                        if let apiLanguage = profileInfo.language {
                                                self.updateLanguage(to: apiLanguage)
                                            }
                       
                        if let calendarVC = (customTabBarController.viewControllers?.first as? UINavigationController)?.viewControllers.first as? CalendarVC {
                            calendarVC.response = response
                            calendarVC.isFromSceneDelegate = true
                        }
                        
                        
                } else {
                    let onboardingVC = OnboardingIntroVC()
                    let navController = UINavigationController(rootViewController: onboardingVC)
                    self.window?.rootViewController = navController
                }
            case .failure(let error):
                if let afError = error.asAFError {
                    if let underlyingError = afError.underlyingError { }
                    switch afError {
                    case .responseValidationFailed(let reason):
                   
                        if case .unacceptableStatusCode(let code) = reason {
                      
                            if code == 404 {
                                let onboardingVC = OnboardingIntroVC()
                                let navController = UINavigationController(rootViewController: onboardingVC)
                                self.window?.rootViewController = navController
                            }
                        }
                    default:
                        print("Diğer AFError: \(afError)")
                    }
                } else {
                  
                }
            }
        }
         
         NotificationManager.shared.requestNotificationPermission { granted in
             if granted {
                 NotificationManager.shared.scheduleMorningReminder()
                 NotificationManager.shared.scheduleAfternoonReminder()
                 NotificationManager.shared.scheduleNightReminder()
                 NotificationManager.shared.scheduleMidweekReminder()
                 NotificationManager.shared.scheduleMondayReminder()
                 NotificationManager.shared.scheduleFridayWeekendReminder()
                 NotificationManager.shared.scheduleWeeklyThemeReminder()
                 NotificationManager.shared.scheduleNotificationsForSpecialDays()
             } else {
                 
             }
             
            
             let formatter = DateFormatter()
             formatter.dateStyle = .none
             formatter.timeStyle = .medium
             formatter.timeZone = TimeZone.current
             let localTime = formatter.string(from: Date())
             
         }

      
         let customTabBarController = CustomTabBarController()
         customTabBarController.selectedIndex = 0
         customTabBarController.modalPresentationStyle = .fullScreen
         self.window?.rootViewController = customTabBarController
         self.window?.makeKeyAndVisible()
     }
     private func updateLanguage(to apiLanguage: String) {
            let languageMapping: [String: String] = [
                "English": "en",
                "Spanish": "es",
                "French": "fr",
                "German": "de",
                "Portuguese": "pt",
                "Arabic": "ar",
                "Chinese": "zh-Hans",
                "Japanese": "ja",
                "Korean": "ko",
                "Hindi": "hi",
                "Indonesian": "id",
                "Thai": "th",
                "Vietnamese": "vi",
                "Italian": "it",
                "Dutch": "nl",
                "Swedish": "sv",
                "Norwegian": "no",
                "Finnish": "fi",
                "Danish": "da",
                "Russian": "ru",
                "Polish": "pl",
                "Czech": "cs",
                "Afrikaans": "af",
                "Brazilian": "pt-BR"
            ]
            
            guard let lprojCode = languageMapping[apiLanguage] else {
               
                return
            }

            Bundle.setLanguage(lprojCode)
           
        }
 }

