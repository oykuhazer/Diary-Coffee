//
//  SaveJournalEntryQuery.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.11.2024.
//

import Foundation

class SaveJournalEntryQuery {
    var userId: String
    var journalEntryId: String
    var journalEntryDate: String
    var coffeeMoodType: String
    var coffeeMomentType: String
    var coffeeType: String
    var coffeeJournalText: String
    var coffeeMomentPhotoList: [[String: String]]
    var coffeeMomentStickerList: [[String: String]]
    
    init(userId: String, journalEntryId: String, journalEntryDate: String, coffeeMoodType: String, coffeeMomentType: String, coffeeType: String, coffeeJournalText: String, coffeeMomentPhotoList: [[String: String]], coffeeMomentStickerList: [[String: String]]) {
        self.userId = userId
        self.journalEntryId = journalEntryId
        self.journalEntryDate = journalEntryDate
        self.coffeeMoodType = coffeeMoodType
        self.coffeeMomentType = coffeeMomentType
        self.coffeeType = coffeeType
        self.coffeeJournalText = coffeeJournalText
        self.coffeeMomentPhotoList = coffeeMomentPhotoList
        self.coffeeMomentStickerList = coffeeMomentStickerList
    }
    
    func getBody() -> [String: Any] {
        return [
            "userId": userId,
            "journalEntryId": journalEntryId,
            "journalEntryDate": journalEntryDate,
            "coffeeMoodType": coffeeMoodType,
            "coffeeMomentType": coffeeMomentType,
            "coffeeType": coffeeType,
            "coffeeJournalText": coffeeJournalText,
            "coffeeMomentPhotoList": coffeeMomentPhotoList,
            "coffeeMomentStickerList": coffeeMomentStickerList
        ]
    }
}

