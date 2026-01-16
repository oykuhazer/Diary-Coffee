//
//  DeleteJournalEntryQuery.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 5.11.2024.
//

import Foundation


class DeleteJournalEntryQuery {
    var userId: String
    var journalEntryId: String

    init(userId: String, journalEntryId: String) {
        self.userId = userId
        self.journalEntryId = journalEntryId
    }
    
    func getBody() -> [String: Any] {
        return [
            "userId": userId,
            "journalEntryId": journalEntryId
        ]
    }
}
