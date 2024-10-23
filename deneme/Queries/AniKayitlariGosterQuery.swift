//
//  AniKayitlariGosterQuery.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 8.10.2024.
//

import Foundation

class AniKayitlariGosterQuery {
    var userId: String
    var eventId: String
    
    init(userId: String, eventId: String) {
        self.userId = userId
        self.eventId = eventId
    }
    
    func getBody() -> [String: String] {
        return [
            "UserId": userId,
            "EventId": eventId
        ]
    }
}
