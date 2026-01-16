//
//  ListJournalEntriesQuery.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.11.2024.
//

import Foundation

class ListJournalEntriesQuery {
    var userId: String
    var journalDate: String
    var journalId: String // Artık opsiyonel değil

    init(userId: String, journalDate: String, journalId: String) {
        self.userId = userId
        self.journalDate = journalDate
        self.journalId = journalId
    }
    
    func getBody() -> [String: Any] {
        return [
            "userId": userId,
            "journalDate": journalDate,
            "journalId": journalId // Her zaman body'ye eklenir
        ]
    }
}
