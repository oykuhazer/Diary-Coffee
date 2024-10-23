//
//  AniKayitlariGosterResponse.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 8.10.2024.
//

import Foundation


struct AniKayitlariResponse: Codable {
    let resultCode: Int
    let resultMessage: String
    let aniListesi: [AniListesi]

    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
        case aniListesi = "AniListesi"
    }
}


struct AniListesi: Codable {
    let userId: String
    let eventId: String
    let eventDescription: String
    let eventDate: String
    let coffeeEventDescription: String
    let images: [Image]

    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
        case eventId = "EventId"
        case eventDescription = "EventDescription"
        case eventDate = "EventDate"
        case coffeeEventDescription = "CoffeeEventDescription"
        case images = "Images"
    }
}


struct Image: Codable {
    let fileName: String
    let documentGUID: String
    let documentCategory: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case fileName = "FileName"
        case documentGUID = "DocumentGUID"
        case documentCategory = "DocumentCategory"
        case imageURL = "ImageURL" // JSON'daki "ImageURL" alanı için
    }
}
