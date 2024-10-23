//
//  AniKaydetQuery.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 7.10.2024.
//

import Foundation

class AniKaydetQuery {
    var userId: String
    var eventId: String
    var eventDescription: String
    var eventDate: String
    var coffeeEventDescription: String
    var images: [[String: Any]] 

    init(userId: String, eventId: String, eventDescription: String, eventDate: String, coffeeEventDescription: String, images: [[String: Any]]) {
        self.userId = userId
        self.eventId = eventId
        self.eventDescription = eventDescription
        self.eventDate = eventDate
        self.coffeeEventDescription = coffeeEventDescription
        self.images = images
    }
    
    func getBody() -> [String: Any] {
        return [
            "UserId": userId,
            "EventId": eventId,
            "EventDescription": eventDescription,
            "EventDate": eventDate,
            "CoffeeEventDescription": coffeeEventDescription,
            "Images": images
        ]
    }
}
