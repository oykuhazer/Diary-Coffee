//
//  UserProfile.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 3.11.2024.
//

import Foundation

class UserProfile: CustomStringConvertible {

    static let shared = UserProfile()

    
   let uuid: String = "82626007-5DD2-46A4-9D52-5AAD479DC66Ds"
    
    /*
    var uuid: String {
        get {
            if let storedUUID = UserDefaults.standard.string(forKey: "UserProfileUUID") {
                return storedUUID
            } else {
                let newUUID = UUID().uuidString
                UserDefaults.standard.set(newUUID, forKey: "UserProfileUUID")
                return newUUID
            }
        }
    } */
     
    var gender: String?
    var name: String?
    var birthDate: Date?
    var styleSelection: String?
    var isNotificationEnabled: Bool = false {
        didSet {
            if !isNotificationEnabled {
                notificationTime = nil
            }
        }
    }
    var notificationTime: Date?
    var notificationTimeString: String?
    var language: String?
    var quantityBeans: Int?
    var isPasscodeEnabled: Bool = false {
        didSet {
            if !isPasscodeEnabled {
                passcodeType = nil
                passcodeCode = nil
            }
        }
    }
    var passcodeType: String?
    var passcodeCode: String?
    
    var purchasedStickers: [Sticker] = []
    var purchasedEmotions: [Emotion] = []
    
    var premium: Bool = false
    var premiumType: String?
    var premiumStartDate: Date?
    var premiumDaysLeft: Int?
    
    var profilePicture: String?

    private init() {}

    
    func resetProfile() {
           UserDefaults.standard.removeObject(forKey: "UserProfileUUID")
           gender = nil
           name = nil
           birthDate = nil
           styleSelection = nil
           isNotificationEnabled = false
           notificationTime = nil
           notificationTimeString = nil
           language = nil
           quantityBeans = nil
           isPasscodeEnabled = false
           passcodeType = nil
           passcodeCode = nil
           purchasedStickers.removeAll()
           purchasedEmotions.removeAll()
           premium = false
           premiumType = nil
           premiumStartDate = nil
           premiumDaysLeft = nil
           profilePicture = nil
       }
    
    func updateProfile(with profileInfo: UserProfileInfo) {
        self.gender = profileInfo.gender
        self.name = profileInfo.name
        self.language = profileInfo.language
        self.quantityBeans = profileInfo.quantityBeans
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.birthDate = dateFormatter.date(from: profileInfo.birthDate)
        self.styleSelection = profileInfo.styleSelection
        self.isNotificationEnabled = profileInfo.isNotificationEnabled
        self.notificationTime = profileInfo.notificationTime.flatMap { dateFormatter.date(from: $0) }
        self.isPasscodeEnabled = profileInfo.isPasscodeEnabled
        self.passcodeType = profileInfo.passcodeType
        self.passcodeCode = profileInfo.passcodeCode
        self.notificationTimeString = profileInfo.notificationTime

        self.purchasedStickers = profileInfo.purchasedFeatures?.stickers ?? []
        self.purchasedEmotions = profileInfo.purchasedFeatures?.emotions ?? []

        self.premium = profileInfo.premium
        self.premiumType = profileInfo.premiumType
        self.premiumStartDate = profileInfo.premiumStartDate.flatMap { dateFormatter.date(from: $0) }
        self.premiumDaysLeft = profileInfo.premiumDaysLeft

        self.profilePicture = profileInfo.profilePicture
    }

    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm" 
        
        let birthDateString = birthDate.map { dateFormatter.string(from: $0) } ?? "N/A"
        let notificationTimeString = notificationTime.map { timeFormatter.string(from: $0) } ?? "N/A"
        let premiumStartDateString = premiumStartDate.map { dateFormatter.string(from: $0) } ?? "N/A"

        let stickersDescription = purchasedStickers.map { "\($0.category): \($0.description)" }.joined(separator: ", ")
        let emotionsDescription = purchasedEmotions.map { "\($0.category): \($0.description)" }.joined(separator: ", ")
        
        return """
        UUID: \(uuid)
        """
    }
}
