//
//  GetUserProfileInformationResponse.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.11.2024.
//

import Foundation

struct GetUserProfileInformationResponse: Codable {
    let resultCode: Int
    let resultMessage: String
    let userProfileInfo: UserProfileInfo?

    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
        case userProfileInfo = "UserProfileInfo"
    }
}

struct UserProfileInfo: Codable {
    let uuid: String
    let gender: String?
    let name: String
    let birthDate: String
    let styleSelection: String?
    let isNotificationEnabled: Bool
    let notificationTime: String?
    let isPasscodeEnabled: Bool
    let passcodeType: String?
    let passcodeCode: String?
    let language: String?
    let quantityBeans: Int?
    let purchasedFeatures: PurchasedFeatures?
    let premium: Bool
    let premiumType: String?
    let premiumStartDate: String?
    let premiumDaysLeft: Int?
    let profilePicture: String?
    enum CodingKeys: String, CodingKey {
        case uuid
        case gender
        case name
        case birthDate = "birthDate"
        case styleSelection = "styleSelection"
        case isNotificationEnabled = "isNotificationEnabled"
        case notificationTime = "notificationTime"
        case isPasscodeEnabled = "isPasscodeEnabled"
        case passcodeType = "passcodeType"
        case passcodeCode = "passcodeCode"
        case language = "language"
        case quantityBeans = "quantityBeans"
        case purchasedFeatures = "purchasedFeatures"
        case premium = "premium"
        case premiumType = "premiumType"
        case premiumStartDate = "premiumStartDate"
        case premiumDaysLeft = "premiumDaysLeft"
        case profilePicture = "profilePicture" 
    }
}

struct PurchasedFeatures: Codable {
    let stickers: [Sticker]
    let emotions: [Emotion]

    enum CodingKeys: String, CodingKey {
        case stickers = "stickers"
        case emotions = "emotions"
    }
}

struct Sticker: Codable {
    let category: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case category = "category"
        case description = "description"
    }
}

struct Emotion: Codable {
    let category: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case category = "category"
        case description = "description"
    }
}

