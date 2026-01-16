//
//  SaveUserProfileQuery.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.11.2024.
//

import Foundation

class SaveUserProfileQuery {
    var uuid: String
    var gender: String
    var name: String
    var birthDate: String
    var styleSelection: String
    var isNotificationEnabled: Bool
    var notificationTime: String
    var isPasscodeEnabled: Bool
    var passcodeType: String
    var passcodeCode: String
    var language: String
    var quantityBeans: Int
    var profilePicture: String?
    var purchasedFeatures: PurchasedFeatures?
    var premium: Bool
    var premiumType: String?
    var premiumStartDate: String?
    var premiumDaysLeft: Int?

    init(uuid: String, gender: String, name: String, birthDate: String, styleSelection: String, isNotificationEnabled: Bool, notificationTime: String, isPasscodeEnabled: Bool, passcodeType: String, passcodeCode: String, language: String, quantityBeans: Int, profilePicture: String?, purchasedFeatures: PurchasedFeatures?, premium: Bool, premiumType: String?, premiumStartDate: String?, premiumDaysLeft: Int?) {
        self.uuid = uuid
        self.gender = gender
        self.name = name
        self.birthDate = birthDate
        self.styleSelection = styleSelection
        self.isNotificationEnabled = isNotificationEnabled
        self.notificationTime = notificationTime
        self.isPasscodeEnabled = isPasscodeEnabled
        self.passcodeType = passcodeType
        self.passcodeCode = passcodeCode
        self.language = language
        self.quantityBeans = quantityBeans
        self.profilePicture = profilePicture
        self.purchasedFeatures = purchasedFeatures
        self.premium = premium
        self.premiumType = premiumType
        self.premiumStartDate = premiumStartDate
        self.premiumDaysLeft = premiumDaysLeft
    }
    
    func getBody() -> [String: Any] {
        var body: [String: Any] = [
            "uuid": uuid,
            "gender": gender,
            "name": name,
            "birthDate": birthDate,
            "styleSelection": styleSelection,
            "isNotificationEnabled": isNotificationEnabled,
            "notificationTime": notificationTime,
            "isPasscodeEnabled": isPasscodeEnabled,
            "passcodeType": passcodeType,
            "passcodeCode": passcodeCode,
            "language": language,
            "quantityBeans": quantityBeans,
            "profilePicture": profilePicture ?? NSNull(),
            "premium": premium,
            "premiumType": premiumType ?? NSNull(),
            "premiumStartDate": premiumStartDate ?? NSNull(),
            "premiumDaysLeft": premiumDaysLeft ?? 0
        ]
        
       
        if let purchasedFeatures = purchasedFeatures {
            body["purchasedFeatures"] = [
                "stickers": purchasedFeatures.stickers.map { sticker in
                    ["category": sticker.category, "description": sticker.description]
                },
                "emotions": purchasedFeatures.emotions.map { emotion in
                    ["category": emotion.category, "description": emotion.description]
                }
            ]
        }
        
        return body
    }
}
