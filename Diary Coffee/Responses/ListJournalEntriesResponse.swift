//
//  ListJournalEntriesResponse.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.11.2024.
//

import Foundation

struct ListJournalEntriesResponse: Codable {
    let resultCode: Int
    let resultMessage: String
    var journalEntriesInfoList: [JournalEntryInfo]?

    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultMessage = "ResultMessage"
        case journalEntriesInfoList = "JournalEntriesInfoList"
    }
}

struct JournalEntryInfo: Codable {
    let journalEntryId: String
    let journalEntryDate: String
    let coffeeMoodType: String
    let coffeeMomentType: String
    let coffeeType: String
    let coffeeJournalText: String
    let coffeeMomentPhotoList: [DocumentInfo]
    let coffeeMomentStickerList: [DocumentInfo]

    enum CodingKeys: String, CodingKey {
        case journalEntryId = "journalEntryId"
        case journalEntryDate = "journalEntryDate"
        case coffeeMoodType = "coffeeMoodType"
        case coffeeMomentType = "coffeeMomentType"
        case coffeeType = "coffeeType"
        case coffeeJournalText = "coffeeJournalText"
        case coffeeMomentPhotoList = "coffeeMomentPhotoList"
        case coffeeMomentStickerList = "coffeeMomentStickerList"
    }
}

struct DocumentInfo: Codable {
    let fileName: String
    let documentGUID: String
    let documentCategory: String
    let base64Data: String?

    enum CodingKeys: String, CodingKey {
        case fileName = "fileName"
        case documentGUID = "documentGUID"
        case documentCategory = "documentCategory"
        case base64Data = "base64Data" 
    }
}

